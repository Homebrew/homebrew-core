class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.17.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.17.tar.lz"
  sha256 "71de39883c25b6fab44add80635382a10c9bf154515b94729f4a6529ddcc5e54"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37681e29529497522f49d21538e9aa3ac82a36419ca1e54e2ef2a0b87cd2bc3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c564d371bbcdfbbe568291254d591c12d220b23a502944aa68d3a890d4f73e3"
    sha256 cellar: :any_skip_relocation, monterey:       "0c7dc67abe4606ed94fa33680fd662e763e1be53320ffb272b7745c1739a5865"
    sha256 cellar: :any_skip_relocation, big_sur:        "57c700308a2ae32fb9a161f33665e040432a0bce4eafc746ece9c1a515b4097d"
    sha256 cellar: :any_skip_relocation, catalina:       "7ed89b34fe7b4120255d4a6bd493a924c07c3ad31f3e8099a81ef526dc60b704"
    sha256 cellar: :any_skip_relocation, mojave:         "2de3bede199b9f95bb617315e8eb8c8e30276dfcda7f17836c9fcc2dc5253580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecd2f65aa59dc4a5748db7e74fe2e840df872b271c31859e2b5991e586a9b47a"
  end

  keg_only :provided_by_macos

  def install
    ENV.deparallelize

    args = ["--prefix=#{prefix}"]
    args << "--program-prefix=g" if OS.mac?

    system "./configure", *args
    system "make"
    system "make", "install"

    if OS.mac?
      %w[ed red].each do |prog|
        (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
        (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
      end
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        All commands have been installed with the prefix "g".
        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:
          PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    testfile = testpath/"test"
    testfile.write "Hello world\n"

    on_macos do
      pipe_output("#{bin}/ged -s #{testfile}", ",s/o//\nw\n", 0)
      assert_equal "Hell world\n", testfile.read

      pipe_output("#{opt_libexec}/gnubin/ed -s #{testfile}", ",s/l//g\nw\n", 0)
      assert_equal "He word\n", testfile.read
    end

    on_linux do
      pipe_output("#{bin}/ed -s #{testfile}", ",s/o//\nw\n", 0)
      assert_equal "Hell world\n", testfile.read
    end
  end
end
