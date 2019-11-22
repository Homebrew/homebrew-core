class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://www.devicetree.org/"
  url "https://www.kernel.org/pub/software/utils/dtc/dtc-1.5.1.tar.xz"
  sha256 "660b74039690fc37013660544d09191834efb58503c73c555c5513ba75ab031f"

  bottle do
    cellar :any
    sha256 "ef6c457347e0d05b02d4f6cf95e271337901bd771275b28cb07834bc7eae7a70" => :catalina
    sha256 "f81433bf0b0c539aa98320607475535cc095241a66eedb9706ab46057c5916a4" => :mojave
    sha256 "a9157293d39e028781397ad121a386d7c3fc61f217f95f0834326e5c0cd591eb" => :high_sierra
    sha256 "166f31f4093b82f486f74c752e2541e1bdd27399744cce5c0b4a65f36dd1a5de" => :sierra
  end

  depends_on "pkg-config" => :build

  def install
    inreplace "libfdt/Makefile.libfdt", "libfdt.$(SHAREDLIB_EXT).1", "libfdt.1.$(SHAREDLIB_EXT)"
    system "make", "NO_PYTHON=1"
    system "make", "NO_PYTHON=1", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    (testpath/"test.dts").write <<~EOS
      /dts-v1/;
      / {
      };
    EOS
    system "#{bin}/dtc", "test.dts"
  end
end
