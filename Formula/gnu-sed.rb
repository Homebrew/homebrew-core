class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftp.gnu.org/gnu/sed/sed-4.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/sed/sed-4.4.tar.xz"
  sha256 "cbd6ebc5aaf080ed60d0162d7f6aeae58211a1ee9ba9bb25623daa6cd942683b"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbb273a424c68a41670b1bdc7630960ed3d81b08d16b4e2de89da3b08d8042f8" => :sierra
    sha256 "9b221159fc84c8774053bf6611f9da3652636f1531a68819f8ca59fc3c7321c1" => :el_capitan
    sha256 "8abddf2922e6151ee21c84f2b997f9cfe55eeadbbe13ca28ea4097afa0c91f9d" => :yosemite
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  conflicts_with "ssed", :because => "both install share/info/sed.info"

  deprecated_option "default-names" => "with-default-names"

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
    if build.without? "default-names" then <<-EOS.undent
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
