class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.3.tar.xz"
  sha256 "b960541c499619efd6afe1fa795402e4733c8e11ebf9fafccc0bb4bccdc5b514"

  bottle do
    cellar :any
    sha256 "9605eb41929a11ec6e330c65b0a0ccef8c052607c9fde52061063fbfb90ad32a" => :mojave
    sha256 "9c21150901667bd9f65a9b894abf076781580e60560d2f610da325b89f96dd96" => :high_sierra
    sha256 "82abc832186859552a9ca620b0f0ddc28474988847338793e0fabcd2ac9ca130" => :sierra
  end

  option "with-default-names", "Do not prepend 'g' to the binary"
  deprecated_option "default-names" => "with-default-names"

  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
      --infodir=#{info}
      --mandir=#{man}
      --with-packager=Homebrew
    ]

    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make"
    system "make", "install"

    if build.without? "default-names"
      (libexec/"gnubin").install_symlink bin/"ggrep" => "grep"
      (libexec/"gnubin").install_symlink bin/"gegrep" => "egrep"
      (libexec/"gnubin").install_symlink bin/"gfgrep" => "fgrep"

      (libexec/"gnuman/man1").install_symlink man1/"ggrep.1" => "grep.1"
      (libexec/"gnuman/man1").install_symlink man1/"gegrep.1" => "egrep.1"
      (libexec/"gnuman/man1").install_symlink man1/"gfgrep.1" => "fgrep.1"
    end
  end

  def caveats
    if build.without? "default-names" then <<~EOS
      The command has been installed with the prefix "g".
      If you do not want the prefix, install using the "with-default-names"
      option.

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
    text_file = testpath/"file.txt"
    text_file.write "This line should be matched"
    cmd = build.with?("default-names") ? "grep" : "ggrep"
    grepped = shell_output("#{bin}/#{cmd} match #{text_file}")
    assert_match "should be matched", grepped
  end
end
