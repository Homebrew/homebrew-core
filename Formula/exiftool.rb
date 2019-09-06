class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # https://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-11.59.tar.gz"
  sha256 "07534906afa3ba20ae2e6746f0166a6706fe4eb53c1e2f799aa3380674b425e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8e418e2e6de7b5ad3168d168acd9a6b22ca72601a8ae85cb4d520740c31edea" => :mojave
    sha256 "80224d63006a3021eaa8bcfef0fe50cd827d929f68bc46037d8b114cf17e5c3b" => :high_sierra
    sha256 "cc67cc87944eb5b722b8f52a01a3ec6a65d3ee04d46be9938d0a3bfd9d0eaac9" => :sierra
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
