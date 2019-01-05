class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.14.2.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.14.2.tar.lz"
  sha256 "f57962ba930d70d02fc71d6be5c5f2346b16992a455ab9c43be7061dec9810db"

  bottle do
    cellar :any_skip_relocation
    sha256 "63b861cc99b23d057c96445a514b1b7a9834e0816d26289e17a85d3f57cecaea" => :mojave
    sha256 "8f81d744b94ceb94b3042369ff93321b2cbd1904cf04f0289b22542d6b68d0cf" => :high_sierra
    sha256 "2bcab4bf26dae3b57ffe1097744191315941b6e26c6a43157e2595bb64f40c17" => :sierra
    sha256 "b891b87205fbfcc593673726193ceb44535155237d09dc17b38359ed5abee125" => :el_capitan
    sha256 "d8d925d35a5e3a08353960f029423b4f6e7427b2ecc916407ae7e541b0ba3cfa" => :yosemite
  end

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--program-prefix=g"
    system "make"
    system "make", "install"

    %w[ed red].each do |prog|
      (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
      (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
    end
  end

  def caveats; <<~EOS
    All commands have been installed with the prefix "g".
    If you need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:
      PATH="#{opt_libexec}/gnubin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "gnuman" directory to your MANPATH from your bashrc as well:
      MANPATH="#{opt_libexec}/gnuman:$MANPATH"
  EOS
  end

  test do
    testfile = testpath/"test"
    testfile.write "Hello world\n"

    pipe_output("#{bin}/ged -s #{testfile}", ",s/o//\nw\n", 0)
    assert_equal "Hell world\n", testfile.read

    pipe_output("#{opt_libexec}/gnubin/ed -s #{testfile}", ",s/l//g\nw\n", 0)
    assert_equal "He word\n", testfile.read
  end
end
