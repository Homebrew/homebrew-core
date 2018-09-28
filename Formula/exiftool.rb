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
    sha256 "fff5493b09dda517dcea7518635fbdbb9ff33829a8a9b3721550d14201355052" => :mojave
    sha256 "6d05a04c4c409b2d31c05693636bae88220a2f602682fe8b241c7bd8bfbebcc1" => :high_sierra
    sha256 "6d05a04c4c409b2d31c05693636bae88220a2f602682fe8b241c7bd8bfbebcc1" => :sierra
    sha256 "6d05a04c4c409b2d31c05693636bae88220a2f602682fe8b241c7bd8bfbebcc1" => :el_capitan
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
