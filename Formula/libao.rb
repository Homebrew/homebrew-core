class Libao < Formula
  desc "Cross-platform Audio Library"
  homepage "https://www.xiph.org/ao/"
  url "https://github.com/xiph/libao/archive/1.2.2.tar.gz"
  sha256 "df8a6d0e238feeccb26a783e778716fb41a801536fe7b6fce068e313c0e2bf4d"
  head "https://git.xiph.org/libao.git"

  bottle do
    sha256 "91469bf8242cf3115d65f6bf39caa77226fc21840309ee5f3fad009379a6fbec" => :sierra
    sha256 "d1e17337705d098d76e4bfd4b71f2bb01278a85a87d58ad0711636a2050c9049" => :el_capitan
    sha256 "a44490fce22700be3b09bc6c75de39d90f7860e2486723bb1fa655e22c0a2771" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "pulseaudio" => :optional

  def install
    ENV["AUTOMAKE_FLAGS"] = "--include-deps"
    system "./autogen.sh"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-static
    ]

    args << "--enable-pulse" if build.with? "pulseaudio"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
