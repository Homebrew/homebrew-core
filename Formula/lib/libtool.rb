class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.7.tar.xz"
  sha256 "4f7f217f057ce655ff22559ad221a0fd8ef84ad1fc5fcb6990cecc333aa1635d"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "211b174c29c24b3bdd42c44a12262ba479c4707b19bd2abd41f41a67f1b45cf5"
    sha256 cellar: :any,                 arm64_ventura:  "a7196b340a6b2ee833b9451409a2e83b08ba192bebe4fd019c6e658789c76298"
    sha256 cellar: :any,                 arm64_monterey: "359d2a8f85d03f310263b91c665bf591703e8a7a6e79396bc2fc64df75e0655a"
    sha256 cellar: :any,                 arm64_big_sur:  "faa1bb0c78ff5881efcaf476ccfc6ec400e56a4583fcc850d265b70f37fd577e"
    sha256 cellar: :any,                 sonoma:         "47676ae503261483d5f1f35caa074efc416527bc471e25b0dc5c19bf588ed39f"
    sha256 cellar: :any,                 ventura:        "d20beb0eb96c3ab67be5987393c64a575781c5d7abe6fb20efd2ae343a0680c7"
    sha256 cellar: :any,                 monterey:       "4b248059b3fed99774183f17e335eca05edb25698dabcecbe916f4ec63a48cc6"
    sha256 cellar: :any,                 big_sur:        "deffadfecec61da06dde9edf5eae19381f80f99ae78e57607732fd54be366b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f55d5bcc07a45f599800b2c9fb5818c13be90803355e169cdb0e1ddc621bee5e"
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
