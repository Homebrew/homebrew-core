# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
  sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"

  revision 1

  bottle do
    cellar :any
    sha256 "ebb50367eb2336ee317841587e24690de124fb2c3e4d346405e9b41c4e6120ae" => :high_sierra
    sha256 "78a1f6c6644eae01eb5c204ef705f7e48721a0fe8ece492c10c84791061885db" => :sierra
    sha256 "b7651d0a082e2f103f03ca3a5ed831e2ff5655ccc1044ac0452e4d1825475a35" => :el_capitan
    sha256 "0eb206c0f51e8ce2e3e9340b5ce3c8ecef961ae6696f676073327a7ac04e5c0b" => :yosemite
    sha256 "2e51ef82ef2bd1ad9d921a9016b9e5d7fa82d131849e2c32a3c90daa119e2eda" => :mavericks
  end

  keg_only :provided_until_xcode43

  def install
    ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix=g",
                          "--enable-ltdl-install"
    system "make", "install"
    # Symlink all commands into libexec/gnubin without the 'g' prefix
    libtool_filenames(bin).each do |cmd|
      (libexec/"bin").install_symlink bin/"g#{cmd}" => cmd
    end
    # Symlink all man(1) pages into libexec/gnuman without the 'g' prefix
    libtool_filenames(man1).each do |cmd|
      (libexec/"man"/"man1").install_symlink man1/"g#{cmd}" => cmd
    end
  end

  def caveats; <<~EOS
    In order to prevent conflicts with Apple's own libtool we have prepended a "g"
    so, you have instead: glibtool and glibtoolize.

    If you really need to use these commands with their normal names, you
    can add a "libtool/libexec/bin" directory to your PATH from your bashrc like:

        PATH="#{opt_libexec}/bin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "libtool/libexec/man" directory to your MANPATH from your bashrc as well:

        MANPATH="#{opt_libexec}/man:$MANPATH"

    EOS
  end

  def libtool_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"
      filenames << path.basename.to_s.sub(/^g/, "")
    end
    filenames.sort
  end

  test do
    system "#{bin}/glibtool", "execute", "/usr/bin/true"
    (testpath/"hello.c").write <<-EOS
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
