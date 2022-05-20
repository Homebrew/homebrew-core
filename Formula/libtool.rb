class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.7.tar.xz"
  sha256 "4f7f217f057ce655ff22559ad221a0fd8ef84ad1fc5fcb6990cecc333aa1635d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5f92327e52a1196e8742cb5b3a64498c811d51aed658355c205858d2a835fdc9"
    sha256 cellar: :any,                 arm64_big_sur:  "6f676b306c72b04dd0e24cc96f51117e91719a4743743dc5527c16bf03f21320"
    sha256 cellar: :any,                 monterey:       "33bf8379256791a8e8752541bf4e182090dcef5f73aa8faa5f6521d16414a6ca"
    sha256 cellar: :any,                 big_sur:        "bae30841faca7f4b91e5388c0db13cd6cc95df0182b6d21a62b4c1ea508ebb69"
    sha256 cellar: :any,                 catalina:       "624bb469bae686405b26ac05706c5f750bed31cd23995a9fa91cc31646e0eadc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cde2899a36adf5b04d25a9b8b4d6bec8a3099bc59ae68c63e479a4da8ca70b3"
  end

  depends_on "m4"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ltdl-install
    ]

    args << "--program-prefix=g" if OS.mac?

    system "./configure", *args
    system "make", "install"

    if OS.mac?
      %w[libtool libtoolize].each do |prog|
        (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
        (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
      end
      libexec.install_symlink "gnuman" => "man"
    end

    if OS.linux?
      bin.install_symlink "libtool" => "glibtool"
      bin.install_symlink "libtoolize" => "glibtoolize"

      # Avoid references to the Homebrew shims directory
      inreplace bin/"libtool", Superenv.shims_path, "/usr/bin"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        All commands have been installed with the prefix "g".
        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:
          PATH="#{opt_libexec}/gnubin:$PATH"
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
