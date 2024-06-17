class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.20.2.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.20.2.tar.lz"
  sha256 "65fec7318f48c2ca17f334ac0f4703defe62037bb13cc23920de077b5fa24523"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "256f07971d6c3531a7e4ff53181ed97c2a3eba36695728b690540a7da40aee2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d79fa7654496b56001cc2375966611fb2acff57b9503ea9c093a2ad12ee67d66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94bbb07a78c169c2052ba0a347efd1456331acf885ac4d0d969445540baa25e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "307e41c5a31b7df5274e91390e7b69f4ef679aac9e946cad02cb4c73023cc4c0"
    sha256 cellar: :any_skip_relocation, ventura:        "44a39cd99e7284851a607084242703e0bf0836fb515845c20a9531222ed2a190"
    sha256 cellar: :any_skip_relocation, monterey:       "e9cfc5a1ab23700ec4c7230335571d58e4de10fedb4a0938c04b9841f55480c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cec09d44599940964ce0b1cd8936746a001df44cf76fac1b65dce2e8e875e378"
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

    if OS.mac?
      pipe_output("#{bin}/ged -s #{testfile}", ",s/o//\nw\n", 0)
      assert_equal "Hell world\n", testfile.read

      pipe_output("#{opt_libexec}/gnubin/ed -s #{testfile}", ",s/l//g\nw\n", 0)
      assert_equal "He word\n", testfile.read
    else
      pipe_output("#{bin}/ed -s #{testfile}", ",s/o//\nw\n", 0)
      assert_equal "Hell world\n", testfile.read
    end
  end
end
