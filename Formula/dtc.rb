class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://www.devicetree.org/"
  url "https://www.kernel.org/pub/software/utils/dtc/dtc-1.5.0.tar.xz"
  sha256 "c672e443c9f7e39f5a7c8e602da6777f9ad55ad70de87de300a43828c8050172"

  bottle do
    cellar :any
    sha256 "5468b1d1b4467b1e5fcc58013c76b938fdb33db45f10d0683f6eb7a72d5c007a" => :mojave
    sha256 "c230e06edc7710720e75e77319d3982f2d8e1e873018df6fdfa25268ae3ea2e1" => :high_sierra
    sha256 "ea5ae5a503636ed53d3dbc87e835c9fa2f3e004b06d871003a9a4617afc87163" => :sierra
    sha256 "6755bc2af0a42c3bb4834c468f36db8248b983d20cb47783afded95ac1267aac" => :el_capitan
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
