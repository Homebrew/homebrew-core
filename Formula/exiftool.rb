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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "107ea49a6a120d031be18ca6f552a8df01c2b74da166394ec6336551f624763d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8956e65756c109506891750840a88e1171fcda9028cf7466df3c6f9f49aa26d2"
    sha256 cellar: :any_skip_relocation, monterey:       "f318bf377de9820dfa35039ff40bb6d193e1d855e2753b9962303f17a923d231"
    sha256 cellar: :any_skip_relocation, big_sur:        "88e0b007181d89405c6597a1a234cbbd44c7b998d288f2335cac898061ff5d57"
    sha256 cellar: :any_skip_relocation, catalina:       "dcec97e9c602263e02fb3459bdb2c8c4537264e308c06869fa8e674520f251a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "084e982832971c5e53308d917b10675b64581ba531ec4f075224e15fb66f9e40"
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
