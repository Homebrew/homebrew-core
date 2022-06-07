class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-12.42.tar.gz"
  mirror "https://exiftool.org/Image-ExifTool-12.42.tar.gz"
  sha256 "31d805ed59f2114f19c569f8a2aaffb89fa211453733d2c650d843a3e46236df"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d440f446b4d3e17f6b03ca37dba81135e6c886abef7850fe951dd7ef32200d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45c78f2098a22750e6040506491726d8ab34b6d5b0b39dd7357d781f3a8b423e"
    sha256 cellar: :any_skip_relocation, monterey:       "89315618ad46482d4cba44899113fbcd47fefe2b2c87c97f261c7d7fa8f882ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0ef378ec45afc7dafa0b76653ac643759b3bdaade2785cdcc41ad0d830f4cee"
    sha256 cellar: :any_skip_relocation, catalina:       "c283bbbba0855fdb085630e7e6393febc820d357fcd600df9e41d1b2c4f941bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6d408ef0f465f15b8165594a28be11114f97f992d5921a4eb5732855101fe91"
  end

  uses_from_macos "perl"

  def install
    # Enable large file support
    # https://exiftool.org/forum/index.php?topic=3916.msg18182#msg18182
    inreplace "lib/Image/ExifTool.pm", "LargeFileSupport => undef", "LargeFileSupport => 1"

    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$1/lib", libexec/"lib"

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
