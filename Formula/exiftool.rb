class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # http://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.55.tar.gz"
  sha256 "029b81a43f423332c00b76b5402fd8f85dee975fad41a734b494faeda4e41f7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "451b7d3b4de25dc5c8758b748db4d472c89635ea85828013b0344f7d837e528f" => :sierra
    sha256 "204b7d815f7830472639f73c8e0882c8689deeb0d3e7f15e6384d21bfdf739ed" => :el_capitan
    sha256 "204b7d815f7830472639f73c8e0882c8689deeb0d3e7f15e6384d21bfdf739ed" => :yosemite
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
