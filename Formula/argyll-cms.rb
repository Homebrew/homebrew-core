class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V2.1.1_src.zip"
  version "2.1.1"
  sha256 "51269bcafc4d95679354b796685c3f0a41b44b78443cbe360cda4a2d72f32acb"

  bottle do
    cellar :any
    sha256 "8cbd53a868a34f7f2a9e3de18cb1d34cbb37507e02657efb9c5adffc1458a346" => :mojave
    sha256 "a3e9c4f3c7eeb2db41592fe91a398342f5084140f193f1a7d6682c5a085f0b0a" => :high_sierra
    sha256 "e55a9debfa319b3853045f276683a717a69b14ad007ca36979bd6e7f4ddd99c5" => :sierra
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
