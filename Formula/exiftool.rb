class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-12.42.tar.gz"
  mirror "https://exiftool.org/Image-ExifTool-12.42.tar.gz"
  sha256 "31d805ed59f2114f19c569f8a2aaffb89fa211453733d2c650d843a3e46236df"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 1

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e424311955c3d99967bbed07db50debfed9679ce818a745c9c00a9baf44e166"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cba13fbd607ab06ed51322537c8872dcd97526e2a73bf0e9068d13385c968b89"
    sha256 cellar: :any_skip_relocation, monterey:       "ec0dc0fef8e628c082a615d6e4d463bc6a49650fc4a05f7ade1c255b3eb68bd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb6f7097abf5fd559d2a9321bc0bb9cefe787b556bc422f5f50a7d1b51d24ac7"
    sha256 cellar: :any_skip_relocation, catalina:       "5a32f4e2cf0bf03b9e8767653e858f0e2bf741b8e684ddf881090e79dd9d9201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77f263d6e8fe29f4ac068e2623a2c0592a227f11e0335f99a24a50b70c02b563"
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
