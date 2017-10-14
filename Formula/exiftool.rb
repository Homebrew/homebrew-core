class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # https://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.55.tar.gz"
  mirror "https://downloads.sourceforge.net/project/exiftool/Image-ExifTool-10.55.tar.gz"
  sha256 "029b81a43f423332c00b76b5402fd8f85dee975fad41a734b494faeda4e41f7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f93de72c6a5d31fd4c98b26547723422d65e36b3d07c0ab8c5b72dd15688f5d7" => :high_sierra
    sha256 "e4961ef70303e176af0a08807bfe2fb75869ebd92d9e29fea14143d79f276728" => :sierra
    sha256 "a1d1ebd07661fe1d42ced9be65c0b75771948f292f1938379628f335b105409b" => :el_capitan
    sha256 "a1d1ebd07661fe1d42ced9be65c0b75771948f292f1938379628f335b105409b" => :yosemite
  end

  devel do
    url "https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.63.tar.gz"
    mirror "https://downloads.sourceforge.net/project/exiftool/Image-ExifTool-10.63.tar.gz"
    sha256 "84d63972e9172cd18fce54fef862f0d818c91c29a79c95689557be31747b9fde"
  end

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$exeDir/lib", libexec/"lib"

    system "perl", "Makefile.PL"
    libexec.install "lib"
    bin.install "exiftool"
    doc.install Dir["html/*"]
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end
