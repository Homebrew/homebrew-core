class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # https://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-11.30.tar.gz"
  mirror "https://downloads.sourceforge.net/project/exiftool/Image-ExifTool-11.30.tar.gz"
  sha256 "3a53733a1532bede4ce7eee763e5ab2bb87149e75e869e11a64d0e159858726e"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6e176ab3141ad2b7d7604383253abd2790687f721a174208f8870dcf8733da8" => :mojave
    sha256 "a6e176ab3141ad2b7d7604383253abd2790687f721a174208f8870dcf8733da8" => :high_sierra
    sha256 "fa6557f353f44dca4c41c79596b9fefb52caaeaf4795b35d262836084df67e08" => :sierra
  end

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$exeDir/lib", libexec/"lib"

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
