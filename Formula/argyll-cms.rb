class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V2.0.0_src.zip"
  version "2.0.0"
  sha256 "5492896c040b406892864c467466ad6b50eb62954b5874ef0eb9174d1764ff41"
  revision 1

  bottle do
    cellar :any
    sha256 "01c60cb156c926f759f5c57e01a39298d0aea1ccb1b811efc3ee3c5110f2622e" => :high_sierra
    sha256 "045fc296278fa225916cfafeeb499439b6ddd5a041a630cfd041831687f47819" => :sierra
    sha256 "edf9250bc28f993481fb89496fbc725e4214e85027ae746bc3c7f4e7fa45dc5d" => :el_capitan
  end

  depends_on "jam" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  conflicts_with "num-utils", :because => "both install `average` binaries"

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Aug 2017 to graeme AT argyllcms DOT com
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "numlib/numsup.c", "CLOCK_MONOTONIC", "UNDEFINED_GIBBERISH"
    end

    system "sh", "makeall.sh"
    system "./makeinstall.sh"
    rm "bin/License.txt"
    prefix.install "bin", "ref", "doc"
  end

  test do
    system bin/"targen", "-d", "0", "test.ti1"
    system bin/"printtarg", testpath/"test.ti1"
    %w[test.ti1.ps test.ti1.ti1 test.ti1.ti2].each do |f|
      assert_predicate testpath/f, :exist?
    end
    assert_match "Calibrate a Display", shell_output("#{bin}/dispcal 2>&1", 1)
  end
end
