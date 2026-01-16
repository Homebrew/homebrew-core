class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftpmirror.gnu.org/gnu/libtool/libtool-2.5.4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/libtool/libtool-2.5.4.tar.xz"
  sha256 "f81f5860666b0bc7d84baddefa60d1cb9fa6fceb2398cc3baca6afaa60266675"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3a7e5f39f3933f3c92daacbc054a38628521aeb6b52fddd2a3c945a897050e5"
    sha256 cellar: :any,                 arm64_sequoia: "f21ea809c3bdc0aa1b25dce05dc05bebd228adb213957df244bf00af760392ef"
    sha256 cellar: :any,                 arm64_sonoma:  "b78cea0747889cff2d5d5308cf2cfebef93f8fe3a5ad87cbadb5ee16f8dbc6a6"
    sha256 cellar: :any,                 arm64_ventura: "f30240dd2c3b9c42be0f4a0dc4f8a9ceabd0d12f28db8e3650076f8d1c59a7bc"
    sha256 cellar: :any,                 tahoe:         "4301ea7f74f94894c95e1dae08326d7f59e3dd7dd70962801ffb129f4664a253"
    sha256 cellar: :any,                 sequoia:       "b86376ec9504b188528c074fb1c5ade15679402ed1e4b20a99b2ac2235780717"
    sha256 cellar: :any,                 sonoma:        "fc28339b3192a79d41f5b67f53f5d232dfed48de66b464c02f21d64536da86d8"
    sha256 cellar: :any,                 ventura:       "5ef401943faf0ebe8c57542bcd4ff976419f9ff67ce1b67e3c5c0b2cf0fa69df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "deecc3ded6794f5ab08b785aa8a1800b3559376a61d369a6798b29e6568c7429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cad7f708b11b5bc65f08dadaab2f3f8c51eb2267efc0cc20ad9a4ce9f7c8134e"
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

    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() { puts("Hello, world!"); return 0; }
    C

    system bin/"glibtool", "--mode=compile", "--tag=CC",
      ENV.cc, "-c", "hello.c", "-o", "hello.o"
    system bin/"glibtool", "--mode=link", "--tag=CC",
      ENV.cc, "hello.o", "-o", "hello"
    assert_match "Hello, world!", shell_output("./hello")

    system bin/"glibtoolize", "--ltdl"
  end
end
