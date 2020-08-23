class Libao < Formula
  desc "Cross-platform Audio Library"
  homepage "https://www.xiph.org/ao/"
  url "https://github.com/xiph/libao/archive/1.2.2.tar.gz"
  sha256 "df8a6d0e238feeccb26a783e778716fb41a801536fe7b6fce068e313c0e2bf4d"
  license "GPL-2.0"
  head "https://gitlab.xiph.org/xiph/libao.git"

  bottle do
    rebuild 2
    sha256 "703bfcae17a364ad0e526d5556b3583d1864c6db4c52ba85ef64dc0600039372" => :catalina
    sha256 "932b3a41565e678489471dae66b29fea1ca2de6013c2559f9c34cc5e9bd5a33f" => :mojave
    sha256 "d7144edd6dc64b987d9a9d584799fe20a76ed92f2b1b18c074a6846926f23169" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    ENV["AUTOMAKE_FLAGS"] = "--include-deps"
    system "./autogen.sh"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-static
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ao/ao.h>
      int main() {
        ao_initialize();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lao", "-o", "test"
    system "./test"
  end
end
