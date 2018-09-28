class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # https://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-11.11.tar.gz"
  mirror "https://downloads.sourceforge.net/project/exiftool/Image-ExifTool-11.11.tar.gz"
  sha256 "e64eee75cdbc0944ea598bade44a2c100e7c940ce7d163cbbd087d2bd00cefeb"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddec4475d058dcd1a6a5ffe5666abf9fa76aeb0bd965aed10f15a80f22a711df" => :mojave
    sha256 "06fbfc9844eab96cd0589d829798e6b0893e7421d136ee2d8b2c759aeb5bc554" => :high_sierra
    sha256 "06fbfc9844eab96cd0589d829798e6b0893e7421d136ee2d8b2c759aeb5bc554" => :sierra
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
