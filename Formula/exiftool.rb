class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # http://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.36.tar.gz"
  sha256 "2019427b6565e2cff3c1301ab3281a40e602e70eff931448a1601b96ef4a67f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "921cb4717bc32a500ab60b890e56e3da65034b64df5f8cefae83af602c8152ef" => :sierra
    sha256 "c82ff86bbbb4d2f5ed8f1aef51858a89699144d54c9d75373fb5a2aa6c93bd21" => :el_capitan
    sha256 "c82ff86bbbb4d2f5ed8f1aef51858a89699144d54c9d75373fb5a2aa6c93bd21" => :yosemite
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
