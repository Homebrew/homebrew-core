class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V2.1.1_src.zip"
  version "2.1.1"
  sha256 "51269bcafc4d95679354b796685c3f0a41b44b78443cbe360cda4a2d72f32acb"

  bottle do
    cellar :any
    sha256 "1051f72544cc48ef2a7ddda49b4dd610000eadeb59a0e06fbdb578fcc212e519" => :mojave
    sha256 "f6a8c6a464f1293d4e50001824009d932269469e9a262c624e87779ba9c69290" => :high_sierra
    sha256 "e7ab5c574f61c660626f10c862d865bf19f3d385428e18a0f4a4375f9e811b2f" => :sierra
  end

  depends_on "jam" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  conflicts_with "num-utils", :because => "both install `average` binaries"

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Aug 2017 to graeme AT argyllcms DOT com
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
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
