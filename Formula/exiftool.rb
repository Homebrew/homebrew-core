class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # http://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.20.tar.gz"
  sha256 "f06ae200950cd3f441f20f7532163365965aa45a91d96114672b0eb176b76d2a"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3637e7ee2e3c54995563a16833b4993b121117554e13ec0d4cbe98c5e9653a8" => :el_capitan
    sha256 "f988ac89821ff960cc564af07fc094deb313e314bf7017397573d69b362de479" => :yosemite
    sha256 "627a623afdbd4fd5a9c4af02cb1228713f70ff68362733000a84890af89c4416" => :mavericks
  end

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$exeDir/lib", libexec/"lib"

    system "perl", "Makefile.PL"
    libexec.install "lib"
    bin.install "exiftool"
  end

  test do
    system bin/"exiftool"
  end
end
