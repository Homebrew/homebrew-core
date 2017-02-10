class Libao < Formula
  desc "Cross-platform Audio Library"
  homepage "https://www.xiph.org/ao/"
  url "https://github.com/xiph/libao/archive/1.2.2.tar.gz"
  sha256 "df8a6d0e238feeccb26a783e778716fb41a801536fe7b6fce068e313c0e2bf4d"
  head "https://git.xiph.org/libao.git"

  bottle do
    rebuild 1
    sha256 "9b64b4e9093363062dc8c939ec0d73d9c22d78776296a9f8557e7d3290b36848" => :sierra
    sha256 "159aa7704f0a3cd36bfdf659ca8ec9c399077274bff1b68aa0497fdda8b6da44" => :el_capitan
    sha256 "08d568c4bed498b2920983d9b848213779164c15489c82cc61429533337d19f5" => :yosemite
    sha256 "81b1d6c5d1920092fba0470db2840414eb99bba8ec63d6d22800e79090db8e4b" => :mavericks
    sha256 "21aa15e92c5577a4a610de8fbb3f5a72638a0c37a40c4ebebc14826359932efa" => :mountain_lion
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
