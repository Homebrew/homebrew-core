class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://www.devicetree.org/"
  url "https://www.kernel.org/pub/software/utils/dtc/dtc-1.6.0.tar.xz"
  sha256 "10503b0217e1b07933e29e8d347a00015b2431bea5f59afe0bed3af30340c82d"
  license any_of: ["GPL-2.0-or-later", "BSD-2-Clause"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/"
    regex(/href=.*?dtc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d83175100dcc9a15426e6bd6de5e31a8d6ca3c7cb24c8ff4cc3bfdce9cf25ffd"
    sha256 cellar: :any, big_sur:       "94b85edc6eca271107edecfa0b2f76b0d98b6bd41ea556c1c1ba150966d940bf"
    sha256 cellar: :any, catalina:      "3cbdb48bb892f6cce39b9cc381f60a9ad8a785ad3582a4f324be8ec4caed7423"
    sha256 cellar: :any, mojave:        "d80813f17abce4b20eb1e656919e9a5ee9d4fd10613b144c61217f3f1febf55c"
    sha256 cellar: :any, high_sierra:   "00273c1cc191558075437f3e1938977cbc22cc84c58bb6b8920acc672d25b85d"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "bison"
  uses_from_macos "flex"

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
