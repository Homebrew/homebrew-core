class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.16.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.16.tar.lz"
  sha256 "cfc07a14ab048a758473ce222e784fbf031485bcd54a76f74acfee1f390d8b2c"

  bottle do
    cellar :any_skip_relocation
    sha256 "aac457bc746b5eca91da8f460d07c78eb82ad0d12918c0a51299c14d94a5856e" => :catalina
    sha256 "639a5594fbb41ac9481087e7ab76fdcca0f0a61be34dd1e0d24cc8b4786636ef" => :mojave
    sha256 "ff2c9457fb43d7785ffadf3b15a95f31c9c77758ccfb97cc3cbac2651309064d" => :high_sierra
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
