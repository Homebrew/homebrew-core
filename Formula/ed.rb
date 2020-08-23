class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.16.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.16.tar.lz"
  sha256 "cfc07a14ab048a758473ce222e784fbf031485bcd54a76f74acfee1f390d8b2c"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c8ffa15f236faed29b760318f598903144a8f30ed6a09161f67578b9789760c9" => :catalina
    sha256 "2d8205eb80873325eb1b485238270df1d0e4ad71212d02f48dffbbdb77b529ed" => :mojave
    sha256 "57b85675d5c24f9fa076b9e115274f03c8ec136a36400956b488d6e11fb37e5c" => :high_sierra
  end

  keg_only :provided_by_macos

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--program-prefix=g"
    system "make"
    system "make", "install"

    %w[ed red].each do |prog|
      (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
      (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    <<~EOS
      All commands have been installed with the prefix "g".
      If you need to use these commands with their normal names, you
      can add a "gnubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/gnubin:$PATH"
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
