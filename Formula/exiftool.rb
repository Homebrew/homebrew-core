class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # https://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-11.59.tar.gz"
  sha256 "07534906afa3ba20ae2e6746f0166a6706fe4eb53c1e2f799aa3380674b425e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc919ff969fc3059feb2f8fc8a7d2ae71a14f06c1e114ef5ad58cc32bc14989d" => :mojave
    sha256 "a753014c186f64b50efeb4d9b9ce60a0a672522f9eeb601ee63a647c2395000a" => :high_sierra
    sha256 "846b7dcbebdd72f1b372e3b75b5a3b80ef3ef518f014885b823a494d5911b845" => :sierra
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
