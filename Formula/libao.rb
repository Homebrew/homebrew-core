class Libao < Formula
  desc "Cross-platform Audio Library"
  homepage "https://www.xiph.org/ao/"
  url "https://github.com/xiph/libao/archive/1.2.2.tar.gz"
  sha256 "df8a6d0e238feeccb26a783e778716fb41a801536fe7b6fce068e313c0e2bf4d"
  head "https://git.xiph.org/libao.git"

  bottle do
    rebuild 1
    sha256 "68e4c903f9da763a466dbec546a50d6d835045879b37dc0e5ad6ca0edd7cb6ae" => :mojave
    sha256 "5ab0149864a6dd0955bc782d4f67dd1c6d1343fcc2ce6983bf4cb3b4ec11d9b1" => :high_sierra
    sha256 "91d709008100b42cc05e28b835155432ab61beee1a8b8337eff5fe0266cba1a1" => :sierra
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
