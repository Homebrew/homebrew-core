class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://www.devicetree.org/"
  url "https://www.kernel.org/pub/software/utils/dtc/dtc-1.6.0.tar.xz"
  sha256 "10503b0217e1b07933e29e8d347a00015b2431bea5f59afe0bed3af30340c82d"

  bottle do
    cellar :any
    sha256 "3cbdb48bb892f6cce39b9cc381f60a9ad8a785ad3582a4f324be8ec4caed7423" => :catalina
    sha256 "d80813f17abce4b20eb1e656919e9a5ee9d4fd10613b144c61217f3f1febf55c" => :mojave
    sha256 "00273c1cc191558075437f3e1938977cbc22cc84c58bb6b8920acc672d25b85d" => :high_sierra
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
