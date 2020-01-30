class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://exiftool.org/Image-ExifTool-11.85.tar.gz"
  sha256 "8b0aaa8e080adfc8736c3b179c140ad3c05dc58a84540f1e56772ce129a8f897"

  bottle do
    cellar :any_skip_relocation
    sha256 "fed471f04fc57bfb8c5710d39a01f1a1176a85cf9cc0de2a9d8120382c287a2b" => :catalina
    sha256 "fed471f04fc57bfb8c5710d39a01f1a1176a85cf9cc0de2a9d8120382c287a2b" => :mojave
    sha256 "f77529e122cbb66d33c511cebdebd8851dba38d42b4f4dd4c0c0a39ae2b0499d" => :high_sierra
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
