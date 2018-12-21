class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftp.gnu.org/gnu/sed/sed-4.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/sed/sed-4.7.tar.xz"
  sha256 "2885768cd0a29ff8d58a6280a270ff161f6a3deb5690b2be6c49f46d4c67bd6a"

  bottle do
    cellar :any_skip_relocation
    sha256 "baa7a3beeb66e472bbeb168edb1352f343cc3459bd5fa8162e4058e1aa8bd1c9" => :mojave
    sha256 "d33646252b0bf303aa5e03f28e11cb89c889eccee21723efff9fa47819ba7b94" => :high_sierra
    sha256 "f5099dae29f92511c0a05566f576854d3b1c5e465a6f4c99b2c8be4fba178605" => :sierra
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
