class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V2.0.1_src.zip"
  version "2.0.1"
  sha256 "7d6542c16118bb93ba252d72bc9562bf2b01d3ae62cc0583cf4331e766b3a512"

  bottle do
    cellar :any
    sha256 "94100f30f5b6b9bf796a0dcf9eeefbcae6cb5fcacb4f31d5ad726c07c108b1f8" => :mojave
    sha256 "c7b3fb56921cc2285eb9a965530128aff808a625ee1807fe605be0c872e93123" => :high_sierra
    sha256 "547e64c39eaaaecd4796a175f83e9217197ee90929b33b1572e9be483d097f3c" => :sierra
    sha256 "433106360daf2a1af397b19ab3790c742c701a8a49e595b60a847d29154d5bb5" => :el_capitan
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
