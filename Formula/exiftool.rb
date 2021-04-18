class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://exiftool.org/Image-ExifTool-12.16.tar.gz"
  sha256 "c140797d72acdaf04f7ce0629867353510b56fbe99ceaac0742bbc379610756a"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a0d8370ee8da32d13b5deb9acfbfa5e460a17c248b358f44c026690a8d22905f"
    sha256 cellar: :any_skip_relocation, big_sur:       "25ff309cacd34da2b0e285b0ae6a1eda155afe8fc76270f881127cef9fea9524"
    sha256 cellar: :any_skip_relocation, catalina:      "8abcffb62ed34374bdb53169396db443b968631904a4450f6b68c9603e9392b9"
    sha256 cellar: :any_skip_relocation, mojave:        "3faea0b5e1f2c4aba9273949f583e06a3a4cf7624b57883cd87f7889f2265989"
  end

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$1/lib", libexec/"lib"

    system "perl", "Makefile.PL"
    system "make", "all"
    libexec.install "lib"
    bin.install "exiftool"
    doc.install Dir["html/*"]
    suffix = ""
    on_linux do
      suffix = "p"
    end
    man1.install "blib/man1/exiftool.1#{suffix}"
    man3.install Dir["blib/man3/*"]
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end
