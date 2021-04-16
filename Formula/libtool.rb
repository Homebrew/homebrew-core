class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
  sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_big_sur: "904c534919bf6dc14fb561dc56012b44af838f8c21fa4e948ff7a7a773b11f20"
    sha256 cellar: :any, big_sur:       "a70ed5b9d74ec3b06bfc202ab36491c3ecd3da4ff2b602478675ba0c533aa466"
    sha256 cellar: :any, catalina:      "9e4b12c13734a5f1b72dfd48aa71faa8fd81bbf2d16af90d1922556206caecc3"
    sha256 cellar: :any, mojave:        "0aa094832dfcc51aadc22056ebf72af91144cb69369043fc6ccc6a052df577aa"
  end

  depends_on "m4"

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
