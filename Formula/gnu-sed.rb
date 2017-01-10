class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftpmirror.gnu.org/sed/sed-4.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/sed/sed-4.3.tar.xz"
  sha256 "47c20d8841ce9e7b6ef8037768aac44bc2937fff1c265b291c824004d56bd0aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea5a119a6a420b2048cc254433622101dd998a91e2367d7e5554447cbc481c03" => :sierra
    sha256 "f01350c5adf68a76c7e541a56a88e65bc480d2551146b404704aace725774a1b" => :el_capitan
    sha256 "ffb7ecd8bcb5795f230b0b6977ddf1c3e851e78a87e22a1137639d556bbe18b6" => :yosemite
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
