class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # http://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.50.tar.gz"
  sha256 "339dd8f771f673fd6c448f4a4b36cf50fe8e3bf884da95aef6cec1d182c0885b"

  bottle do
    cellar :any_skip_relocation
    sha256 "a452876e071f1fb7a3943e8113f9f7e81ed914f2a2ad9c0fd19810d6dff5a69d" => :sierra
    sha256 "53ed9abc1a9f35b274e42a94871dd552459836a03f9dc61450e6911a362f7788" => :el_capitan
    sha256 "53ed9abc1a9f35b274e42a94871dd552459836a03f9dc61450e6911a362f7788" => :yosemite
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
