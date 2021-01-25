class Libnsl < Formula
  desc "Public client interface for NIS(YP) and NIS+"
  homepage "https://github.com/thkukuk/libnsl"
  url "https://github.com/thkukuk/libnsl/archive/v1.3.0.tar.gz"
  sha256 "8e88017f01dd428f50386186b0cd82ad06c9b2a47f9c5ea6b3023fc6e08a6b0f"
  license "LGPL-2.1-or-later"

  keg_only "it conflicts with glibc"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libtirpc"
  depends_on :linux

  uses_from_macos "m4" => :build

  def install
    inreplace "po/Makefile.in.in" do |s|
      s.gsub! /GETTEXT_MACRO_VERSION =.*/,
        "GETTEXT_MACRO_VERSION = #{Formula["gettext"].version.to_s[/(\d\.\d+)/, 1]}"
    end
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rpcsvc/nis.h>

      int main(int argc, char *argv[]) {
          if(NIS_PK_NONE != 0)
              return 1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnsl", "-o", "test"
    system "./test"
  end
end
