class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftp.gnu.org/gnu/sed/sed-4.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/sed/sed-4.5.tar.xz"
  sha256 "7aad73c8839c2bdadca9476f884d2953cdace9567ecd0d90f9959f229d146b40"

  bottle do
    cellar :any_skip_relocation
    sha256 "16bb9d9e40f9be04ec58a032adae5253587b44baa9f52f2f01ae639a783ff35c" => :mojave
    sha256 "c90da39dbe361289afdee0ae58c4051fefb1b06be98fe45706def032dd845a9e" => :high_sierra
    sha256 "d72b58ec90566fdc5504b0de2d63cf0963eecd5e1d9cfe1f35408ac5ab5df79d" => :sierra
    sha256 "adc343fd5375908e69fe8c770588128f3e8459b8997aaf62933e0a2229c626d4" => :el_capitan
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  deprecated_option "default-names" => "with-default-names"

  conflicts_with "ssed", :because => "both install share/info/sed.info"

  def install
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"

    if build.without? "default-names"
      (libexec/"gnubin").install_symlink bin/"gsed" =>"sed"
      (libexec/"gnuman/man1").install_symlink man1/"gsed.1" => "sed.1"
    end
  end

  def caveats
    if build.without? "default-names" then <<~EOS
      The command has been installed with the prefix "g".
      If you do not want the prefix, install using the "with-default-names" option.

      If you need to use these commands with their normal names, you
      can add a "gnubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/gnubin:$PATH"

      Additionally, you can access their man pages with normal names if you add
      the "gnuman" directory to your MANPATH from your bashrc as well:
        MANPATH="#{opt_libexec}/gnuman:$MANPATH"
    EOS
    end
  end

  test do
    (testpath/"test.txt").write "Hello world!"
    if build.with? "default-names"
      system "#{bin}/sed", "-i", "s/world/World/g", "test.txt"
    else
      system "#{bin}/gsed", "-i", "s/world/World/g", "test.txt"
    end
    assert_match /Hello World!/, File.read("test.txt")
  end
end
