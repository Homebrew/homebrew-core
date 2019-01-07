class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.15.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.15.tar.lz"
  sha256 "ad4489c0ad7a108c514262da28e6c2a426946fb408a3977ef1ed34308bdfd174"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ed0cabb2ba92e925ba0b3e2b7855d64a19a7a27859e9b720499256ab3ac81e3" => :mojave
    sha256 "abc871de2b137bef3b83c021e597191cf5e2b4e1209866e8998f5241b0fbd217" => :high_sierra
    sha256 "b20f41078e1ded8eb4a6de0f20ddaa653b05627857685b4ffe59045eb8780885" => :sierra
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
