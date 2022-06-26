class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://www.devicetree.org/"
  url "https://www.kernel.org/pub/software/utils/dtc/dtc-1.6.1.tar.xz"
  sha256 "65cec529893659a49a89740bb362f507a3b94fc8cd791e76a8d6a2b6f3203473"
  license any_of: ["GPL-2.0-or-later", "BSD-2-Clause"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/"
    regex(/href=.*?dtc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "02031d0f89783e390f8618489d5f27ed62324afc53a920288ba66eb0da8b2056"
    sha256 cellar: :any,                 arm64_big_sur:  "3acf8dbcf556c2271a6162ee0d7e6aa4b1e2f2ffb8dd88541d44ed3a96eecdd5"
    sha256 cellar: :any,                 monterey:       "139c9cea5c83b9927a0a53898dc357a3b1f438a0c92539adc0c02c701d99613b"
    sha256 cellar: :any,                 big_sur:        "eed133a2432f709556facdfb154a34ce5d2bddd6b04c67de73421bee3eb35160"
    sha256 cellar: :any,                 catalina:       "d1910b920613b43b1be2a70ad950139fcd5e908ab45bc9c68dbaba078c676599"
    sha256 cellar: :any,                 mojave:         "98c38049acdae747c9939bbe271f4318e35d976687caaf6beea0527592e4274d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20225ca2fdcdf29d6fff97dddf7a26d39617bf4c6dc6adb3dc1da31f86de47fb"
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
