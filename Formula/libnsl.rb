class Libnsl < Formula
  desc "Public client interface for NIS(YP) and NIS+"
  homepage "https://github.com/thkukuk/libnsl"
  url "https://github.com/thkukuk/libnsl/archive/v2.0.0.tar.gz"
  sha256 "eb37be57c1cf650b3a8a4fc7cd66c8b3dfc06215b41956a16325a9388171bc40"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3b5adecb3863612dbba0ab392e1c33b9c69b6e68532c30eaa6b7032181bfc855"
  end

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
      s.gsub!(/GETTEXT_MACRO_VERSION =.*/,
        "GETTEXT_MACRO_VERSION = #{Formula["gettext"].version.to_s[/(\d\.\d+)/, 1]}")
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
