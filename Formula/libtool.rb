class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
  sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"
  revision 2

  bottle do
    cellar :any
    sha256 "38212486e78db33048438cffe38b6914f13553e7bb8c7d3d2fbecb18a6481d3c" => :catalina
    sha256 "c92ab35c3706c255a36b733aa7a475159da9cf375c275d230fd6a7802a94e4dc" => :mojave
    sha256 "ebb50367eb2336ee317841587e24690de124fb2c3e4d346405e9b41c4e6120ae" => :high_sierra
    sha256 "78a1f6c6644eae01eb5c204ef705f7e48721a0fe8ece492c10c84791061885db" => :sierra
    sha256 "b7651d0a082e2f103f03ca3a5ed831e2ff5655ccc1044ac0452e4d1825475a35" => :el_capitan
    sha256 "0eb206c0f51e8ce2e3e9340b5ce3c8ecef961ae6696f676073327a7ac04e5c0b" => :yosemite
    sha256 "2e51ef82ef2bd1ad9d921a9016b9e5d7fa82d131849e2c32a3c90daa119e2eda" => :mavericks
  end

  uses_from_macos "m4" => :build

  # Fixes the build on macOS 11:
  # https://lists.gnu.org/archive/html/libtool-patches/2020-06/msg00001.html
  patch :p0 do
    url "https://github.com/Homebrew/formula-patches/raw/e5fbd46a25e35663059296833568667c7b572d9a/libtool/dynamic_lookup-11.patch"
    sha256 "5ff495a597a876ce6e371da3e3fe5dd7f78ecb5ebc7be803af81b6f7fcef1079"
  end

  def install
    # Ensure configure is happy with the patched files
    %w[aclocal.m4 libltdl/aclocal.m4 Makefile.in libltdl/Makefile.in
       config-h.in libltdl/config-h.in configure libltdl/configure].each do |file|
      touch file
    end

    ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix=g",
                          "--enable-ltdl-install"
    system "make", "install"
  end

  def caveats
    <<~EOS
      In order to prevent conflicts with Apple's own libtool we have prepended a "g"
      so, you have instead: glibtool and glibtoolize.
    EOS
  end

  test do
    system "#{bin}/glibtool", "execute", "/usr/bin/true"
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() { puts("Hello, world!"); return 0; }
    EOS
    system bin/"glibtool", "--mode=compile", "--tag=CC",
      ENV.cc, "-c", "hello.c", "-o", "hello.o"
    system bin/"glibtool", "--mode=link", "--tag=CC",
      ENV.cc, "hello.o", "-o", "hello"
    assert_match "Hello, world!", shell_output("./hello")
  end
end
