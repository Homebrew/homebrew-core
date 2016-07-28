class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # http://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.20.tar.gz"
  sha256 "f06ae200950cd3f441f20f7532163365965aa45a91d96114672b0eb176b76d2a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9fb91703a0c28f3bdd0b67e90aedb02ff6cdc62c6e8bcf7d203dd5bd5afa644" => :el_capitan
    sha256 "58c7082ea8b8bd8c9ac3585c37913c16d4dcf583b04d9a2edf2916971d452050" => :yosemite
    sha256 "5d0dc199dfd5b7e0db54949ad1ebeea66d5db13f004993b1259620412f13d71b" => :mavericks
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
