class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # http://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.50.tar.gz"
  sha256 "339dd8f771f673fd6c448f4a4b36cf50fe8e3bf884da95aef6cec1d182c0885b"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ea5573b988fa6288eb3c238f7bd3a462b44c25d9555a3d7d64f52638d0110ac" => :sierra
    sha256 "2c48acc68eeeca7a610abc45c1eb0acb64c69682090654e2c3e54d23929497a0" => :el_capitan
    sha256 "2c48acc68eeeca7a610abc45c1eb0acb64c69682090654e2c3e54d23929497a0" => :yosemite
  end

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$exeDir/lib", libexec/"lib"

    system "perl", "Makefile.PL"
    libexec.install "lib"
    bin.install "exiftool"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end
