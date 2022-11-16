class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-12.50.tar.gz"
  mirror "https://exiftool.org/Image-ExifTool-12.50.tar.gz"
  sha256 "bce841fc5c10302f0f3ef7678c3bf146953a8c065c0ba18c41f734007e2ec0a8"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b37887c8ff3fa3be1526f5916e9b67ef97c19b9320028f2fa0a31bb34276d8d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b37887c8ff3fa3be1526f5916e9b67ef97c19b9320028f2fa0a31bb34276d8d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86e334f07d75121f937d2b0bac40787626a5abcb4222f044a9a7cb98993d8396"
    sha256 cellar: :any_skip_relocation, ventura:        "dcf4b052ee5c8cc96cc90a8b514f1c6117a5792e40b0f8d97983c991ad4eab51"
    sha256 cellar: :any_skip_relocation, monterey:       "dcf4b052ee5c8cc96cc90a8b514f1c6117a5792e40b0f8d97983c991ad4eab51"
    sha256 cellar: :any_skip_relocation, big_sur:        "71467ad6fc4d358e207845142ab8fa709f6abb746261e3007940fd732a33b72f"
    sha256 cellar: :any_skip_relocation, catalina:       "f7d892599342e76812b207a804ce906179f188dbf189729d9d9caec2a8e43d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a7936fe430d4f1430ef2eda8550527a06d8981be0257015532f577a581f4f4d"
  end

  uses_from_macos "perl"

  def install
    # Enable large file support
    # https://exiftool.org/forum/index.php?topic=3916.msg18182#msg18182
    inreplace "lib/Image/ExifTool.pm", "LargeFileSupport => undef", "LargeFileSupport => 1"

    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "unshift @INC, $incDir;", "unshift @INC, \"#{libexec}/lib\";"

    system "perl", "Makefile.PL"
    system "make", "all"
    libexec.install "lib"
    bin.install "exiftool"
    doc.install Dir["html/*"]
    man1.install "blib/man1/exiftool.1"
    man3.install Dir["blib/man3/*"]
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end
