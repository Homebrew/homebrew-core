class Libart < Formula
  desc "Library for high-performance 2D graphics"
  homepage "https://github.com/armon/libart"
  url "https://download.gnome.org/sources/libart_lgpl/2.3/libart_lgpl-2.3.21.tar.bz2"
  sha256 "fdc11e74c10fc9ffe4188537e2b370c0abacca7d89021d4d303afdf7fd7476fa"
  license "LGPL-2.0-or-later"

  # We use a common regex because libart doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libart_lgpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5ef5d23e77d46adf971b467cdba6493e2ffb2dc153042ebc994723c8f0fd0317"
    sha256 cellar: :any,                 arm64_sequoia:  "3a01d5d537487e82c16a96a58e50cbfc189c6e2312fc9b93ce3d0ae110585a00"
    sha256 cellar: :any,                 arm64_sonoma:   "b966bb5a144183755880f3256404abc104d91444d10620c9cafd847bcc76265d"
    sha256 cellar: :any,                 arm64_ventura:  "6264e9bdd039ee87e34893b8565f776309f21d9e0730a1cf48fa801453369cd5"
    sha256 cellar: :any,                 arm64_monterey: "5dc4edf96205d8064d34eca369566f41be1b0df69c4a598bece713550e5aeb26"
    sha256 cellar: :any,                 arm64_big_sur:  "8daf6e0691d2fc7f919716cb760a80bbba53295aa5c92d8b05aef4aa1172b09b"
    sha256 cellar: :any,                 sonoma:         "084ad1df397fb243b05af1b4d7a6c8856f2d6687c2cf60bdc31dbc9a3c3cf63c"
    sha256 cellar: :any,                 ventura:        "9547ae5b20144048c3c37a7486a06cc50e6b4d6b4924c2a15fda580765b2abb3"
    sha256 cellar: :any,                 monterey:       "0d0cecb8fccc2fc80a1268bda9c863dae95b45c1cacd73da5e8182d513d41241"
    sha256 cellar: :any,                 big_sur:        "1204889805658d4aeb3ec37251e8ab064e995654008be97588bc034505b77314"
    sha256 cellar: :any,                 catalina:       "54ca46ebc37bba1fdc39e8b28c166202e7d488d93cc5b4acfb042a14adec84f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cd57523ef3d776e1c33ceb83f155ed36426f1f109847b004052cd748f8c20146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b28ae4a3601b0bace6e40c19e616e2e321f17231a378241dae4aa9db9764d75"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/libart2-config --version")

    (testpath/"test.c").write <<~EOS
      #include <libart_lgpl/art_svp.h>
      int main(void) {
        return 0;
      }
    EOS

    system ENV.cc, "-o", "test", "test.c", "-I#{include}/libart-2.0", "-L#{lib}", "-lart_lgpl_2"
    system "./test"
  end
end
