class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "https://github.com/wanduow/libprotoident"
  url "https://github.com/LibtraceTeam/libprotoident/archive/refs/tags/2.0.15-2.tar.gz"
  sha256 "2b43a492fe1d7ada2e7b7b164c8e35220b35bf816bd971c7f77decc74b69801e"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f79ee7ff4e6f80d27d5137297a908e5d03ef51b4acffb080725e869a6e56ce09"
    sha256 cellar: :any,                 arm64_ventura:  "ea8e7da575aeec817cab4748e0f27b304ffef04656bf8925a7fe0e43c446bfb8"
    sha256 cellar: :any,                 arm64_monterey: "8ace9b58b751f6fdb761ff949f271c239143232e72e259619ce7053f2de430d7"
    sha256 cellar: :any,                 arm64_big_sur:  "2fc5f6991116f9d63e327f05905affc40219b75a60eee637f2d6f5dc4f59d6e1"
    sha256 cellar: :any,                 sonoma:         "27514db399bbf3a0ac9466eab131d61a39c05dff2d9a3a6f7df0e66a6e3d82a1"
    sha256 cellar: :any,                 ventura:        "c3a42911911468bc01a9fc0d1d5f0cbedaf60534ad6b9d1618eb22d53191b144"
    sha256 cellar: :any,                 monterey:       "3ad6e71b4d5a2857eabee4604eae32bd5f8888afb9532f6b984d5379548f3bb1"
    sha256 cellar: :any,                 big_sur:        "56c72764357f942f42eb087698db4dfa1ca54ec8e2d80a30a66298c73ce49a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "538f5938a6c533c1102a3c8d0b49d3e298e67b085fbca1fe8b8a71d92ae4f242"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libflowmanager"
  depends_on "libtrace"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libprotoident.h>

      int main() {
        lpi_init_library();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lprotoident", "-o", "test"
    system "./test"
  end
end
