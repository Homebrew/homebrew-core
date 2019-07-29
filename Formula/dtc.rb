class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://www.devicetree.org/"
  url "https://www.kernel.org/pub/software/utils/dtc/dtc-1.5.0.tar.xz"
  sha256 "c672e443c9f7e39f5a7c8e602da6777f9ad55ad70de87de300a43828c8050172"

  bottle do
    cellar :any
    sha256 "a153daba5d7e2d361cc072a310379a939c8a83986584a1899edba80371e04b56" => :mojave
    sha256 "d64946a773558b22387e1e251185180d386b592828d87c166fa43dbd35cdbf1f" => :high_sierra
    sha256 "21635cfd955fbcd9de3a48a3e8203725c1a194e48d11eade6c95d8f481fc8e7f" => :sierra
  end

  depends_on "pkg-config" => :build

  def install
    system "make", "NO_PYTHON=1"
    system "make", "NO_PYTHON=1", "DESTDIR=#{prefix}", "PREFIX=", "install"
    mv lib/"libfdt.dylib.1", lib/"libfdt.1.dylib"
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
