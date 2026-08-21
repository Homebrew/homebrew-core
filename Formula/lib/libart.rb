class Libart < Formula
  desc "Library for high-performance 2D graphics"
  homepage "https://gitlab.gnome.org/Archive/libart_lgpl"
  url "https://download.gnome.org/sources/libart_lgpl/2.3/libart_lgpl-2.3.21.tar.bz2"
  sha256 "fdc11e74c10fc9ffe4188537e2b370c0abacca7d89021d4d303afdf7fd7476fa"
  license "LGPL-2.0-or-later"

  # We use a common regex because libart doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libart_lgpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "53304bb1b776948ef6b9bd1a57a6f18be0b60fefee04e6fc107ece7e31939f3f"
    sha256 cellar: :any, arm64_sequoia: "de3242b54a2271d41f9a2ad9a54ad56211a71d20a98efdceaebf8202e39cd304"
    sha256 cellar: :any, arm64_sonoma:  "a9fbb96bc9d2b1ecabb2ae03143bc1f722e655a09fc057e5e88f3c1dd3c03701"
    sha256 cellar: :any, sonoma:        "2297b2b9a168d0870e069efa0718ef30ebd0afcb0af636e35922e6b1665ad373"
    sha256 cellar: :any, arm64_linux:   "4df630f902f3e455534208b71838cb1919ff13564a48797a992b5394bc3ca11b"
    sha256 cellar: :any, x86_64_linux:  "348b3a8eafa51bc243132a60926c566d942e2fe9d67f8fe3d5028dbfd6abe536"
  end

  deprecate! date: "2026-07-17", because: :repo_archived
  disable! date: "2027-01-17", because: :repo_archived

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
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

    (testpath/"test.c").write <<~C
      #include <libart_lgpl/art_svp.h>
      int main(void) {
        return 0;
      }
    C

    system ENV.cc, "-o", "test", "test.c", "-I#{include}/libart-2.0", "-L#{lib}", "-lart_lgpl_2"
    system "./test"
  end
end
