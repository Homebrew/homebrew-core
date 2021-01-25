class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
  sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "b5dba5a59ae66f42b012998e08edbeaed9e2456c0d1670307b8f46be5ef3b9fa" => :big_sur
    sha256 "c4f95f52617ef0d9a6ec19b5c581241be4593497cd120e42621f55b0ae9548b6" => :arm64_big_sur
    sha256 "af317b35d0a394b7ef55fba4950735b0392d9f31bececebf9c412261c23a01fc" => :catalina
    sha256 "77ca68934e7ed9b9b0b8ce17618d7f08fc5d5a95d7b845622bf57345ffb1c0d6" => :mojave
    sha256 "60c7d86f9364e166846f8d3fb2ba969e6ca157e7ecbbb42a1de259116618c2ba" => :high_sierra
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

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ltdl-install
    ]

    on_macos do
      args << "--program-prefix=g"
    end

    system "./configure", *args
    system "make", "install"

    on_linux do
      bin.install_symlink "libtool" => "glibtool"
      bin.install_symlink "libtoolize" => "glibtoolize"

      # Avoid references to the Homebrew shims directory
      inreplace bin/"libtool", HOMEBREW_SHIMS_PATH/"linux/super/", "/usr/bin/"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        In order to prevent conflicts with Apple's own libtool we have prepended a "g"
        so, you have instead: glibtool and glibtoolize.
      EOS
    end
  end

  test do
    system "#{bin}/glibtool", "execute", File.executable?("/usr/bin/true") ? "/usr/bin/true" : "/bin/true"
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
