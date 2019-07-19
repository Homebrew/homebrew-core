class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # https://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "https://sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-11.57.tar.gz"
  sha256 "6ba1b2eb433637661781be239feda1f6101889a0925d3e58bbe51a4901842aed"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f94aa499cdd29681af5edd77803eaa42b1aab615f77f72aa6d9667b88a2b79c" => :mojave
    sha256 "5b370ff814da1bbbe715cc35f669dfee31cb9faa6b896846d9b7ba67878dcc59" => :high_sierra
    sha256 "5f46c6d11f0521d3da9c8a16f73529848470fdb3bd93033fa619735a3b9ba476" => :sierra
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
