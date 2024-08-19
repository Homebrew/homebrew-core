class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.7.tar.xz"
  sha256 "4f7f217f057ce655ff22559ad221a0fd8ef84ad1fc5fcb6990cecc333aa1635d"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "53032e6f9f95662e8d7e5776c13d99e526f27aa91046b379537e6c9926328532"
    sha256 cellar: :any,                 arm64_ventura:  "ddc4cbe56b2858f9e653d6c675e2e0a5a283748d1e21192963f9d5d828d9b4c8"
    sha256 cellar: :any,                 arm64_monterey: "c075f2068699ea5ad408b952a58d9b0721072905014490d3adcc42c5636b9491"
    sha256 cellar: :any,                 sonoma:         "774349ad71c3a2d6c2e0680939b995833d0c936fbb7dcf711a7b4503f986f0e6"
    sha256 cellar: :any,                 ventura:        "abebe5e185ad6d66e8798be461ccbb2bf2ef58e5da78376713f760d0929098ee"
    sha256 cellar: :any,                 monterey:       "eee91ce66c36b14328492b85f7fb4dd4bbe25c84fe48cda37352ca071faf4d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b4b093e7110026279c01fe6604308e0cc0e2ce4e341852f5cea87d944a59be1"
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
