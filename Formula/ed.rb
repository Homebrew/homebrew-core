class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.17.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.17.tar.lz"
  sha256 "71de39883c25b6fab44add80635382a10c9bf154515b94729f4a6529ddcc5e54"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "57c700308a2ae32fb9a161f33665e040432a0bce4eafc746ece9c1a515b4097d" => :big_sur
    sha256 "5c564d371bbcdfbbe568291254d591c12d220b23a502944aa68d3a890d4f73e3" => :arm64_big_sur
    sha256 "7ed89b34fe7b4120255d4a6bd493a924c07c3ad31f3e8099a81ef526dc60b704" => :catalina
    sha256 "2de3bede199b9f95bb617315e8eb8c8e30276dfcda7f17836c9fcc2dc5253580" => :mojave
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
