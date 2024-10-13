class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftp.gnu.org/gnu/libtool/libtool-2.5.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/libtool/libtool-2.5.3.tar.xz"
  sha256 "898011232cc59b6b3bbbe321b60aba9db1ac11578ab61ed0df0299458146ae2e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f26cc2d321343e11736fa4f7aea031651544291262584c0c94f5b6269422a29"
    sha256 cellar: :any,                 arm64_sonoma:  "e857244e8cf19dd0d0005ab9ad0a3a180e61285dcb981fd6deda5c2e362d98cd"
    sha256 cellar: :any,                 arm64_ventura: "904b1aba635748ba67a6c8e64264edef34e9ab444faee45def5b6a5689942a8b"
    sha256 cellar: :any,                 sonoma:        "169193ec2d3672a4b13cdcad155723ee0ea03fdc726db81213569f6aa2a83246"
    sha256 cellar: :any,                 ventura:       "c35e90a528d4351c4b8c6b2d244dcec015851393fccd88e96d09f1497bed6274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91784670a1d9f78f471156a9d9633529d0ae06599f64de93de4210ac95f96b3f"
  end

  depends_on "m4"

  def install
    ENV["M4"] = Formula["m4"].opt_bin/"m4"

    args = %w[
      --disable-silent-rules
      --enable-ltdl-install
    ]
    args << "--program-prefix=g" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"

    if OS.mac?
      %w[libtool libtoolize].each do |prog|
        (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
        (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
      end
      (libexec/"gnubin").install_symlink "../gnuman" => "man"
    else
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
    system bin/"glibtool", "execute", File.executable?("/usr/bin/true") ? "/usr/bin/true" : "/bin/true"

    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() { puts("Hello, world!"); return 0; }
    EOS

    system bin/"glibtool", "--mode=compile", "--tag=CC",
      ENV.cc, "-c", "hello.c", "-o", "hello.o"
    system bin/"glibtool", "--mode=link", "--tag=CC",
      ENV.cc, "hello.o", "-o", "hello"
    assert_match "Hello, world!", shell_output("./hello")

    system bin/"glibtoolize", "--ltdl"
  end
end
