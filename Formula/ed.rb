class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.14.2.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.14.2.tar.lz"
  sha256 "f57962ba930d70d02fc71d6be5c5f2346b16992a455ab9c43be7061dec9810db"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d3c38fddb44fd9722721be45178d124576ce58fdeb4deafbc38878bee117fb3f" => :mojave
    sha256 "79fc86f8994588aed2b0316d58954f5f404e9e9b6f18ef7833b13d3cbd94aefa" => :high_sierra
    sha256 "e670e43bf5e62d0c131828c0e5a0e6760f68904fc787fc2bf9538f68025b6590" => :sierra
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
