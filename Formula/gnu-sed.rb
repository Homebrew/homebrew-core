class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftp.gnu.org/gnu/sed/sed-4.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/sed/sed-4.7.tar.xz"
  sha256 "2885768cd0a29ff8d58a6280a270ff161f6a3deb5690b2be6c49f46d4c67bd6a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f253301f0bce1c470b77a4230b173a9e6cd70c21c94ff83ae148aa2b8e315b0a" => :mojave
    sha256 "29288f1d0da2301218a31f2efb219f9bd627c2b52a646fd570273a4f38cc580c" => :high_sierra
    sha256 "5c090deefc2dd3769191d97378b981b2dfdd64f1e0259de22682d434ad07e427" => :sierra
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
