class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://www.devicetree.org/"
  url "https://www.kernel.org/pub/software/utils/dtc/dtc-1.5.1.tar.xz"
  sha256 "660b74039690fc37013660544d09191834efb58503c73c555c5513ba75ab031f"

  bottle do
    cellar :any
    sha256 "a153daba5d7e2d361cc072a310379a939c8a83986584a1899edba80371e04b56" => :mojave
    sha256 "d64946a773558b22387e1e251185180d386b592828d87c166fa43dbd35cdbf1f" => :high_sierra
    sha256 "21635cfd955fbcd9de3a48a3e8203725c1a194e48d11eade6c95d8f481fc8e7f" => :sierra
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
