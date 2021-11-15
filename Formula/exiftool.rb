class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-12.30.tar.gz"
  mirror "https://exiftool.org/Image-ExifTool-12.30.tar.gz"
  sha256 "3be7cda70b471df589c75a4adbb71bae62e633022b0ba62585f3bcd91b35544f"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b872e06e2a9544418994622bc7ec701a2c6ba029a95072684ea627fe6817d4a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95b4d728377c063ff92c7a9b3fe3562bfa2cf6193aaf69bc4e168a5574228c4c"
    sha256 cellar: :any_skip_relocation, monterey:       "6d7c3bd90e98c38c64e39a2e66175669a312fd3fae975ace17db2daa174ef2d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "43726e8ab33280185f1444d05bf3517c8dbca843d6989122624054ec53ed96fb"
    sha256 cellar: :any_skip_relocation, catalina:       "8ca86536d8310a0526a3c086196f545a200d338e1ba1bb906d7a7a2efa4b248b"
    sha256 cellar: :any_skip_relocation, mojave:         "8ca86536d8310a0526a3c086196f545a200d338e1ba1bb906d7a7a2efa4b248b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d55c401cc6b9ea4bb8940684661341366f2c7876e0b4efc51cf2c477bc4970f8"
  end

  uses_from_macos "perl"

  def install
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
