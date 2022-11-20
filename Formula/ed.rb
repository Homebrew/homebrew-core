class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.18.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.18.tar.lz"
  sha256 "aca8efad9800c587724a20b97aa8fc47e6b5a47df81606feaba831b074462b4f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2032af54afbacd9cdb684ca0365724700431472163f09ef424a95fc8b47717c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e11a548c78fe21d0e7b4d87e96cd3318df87754e86143d04cc395d62e3d23240"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0a969e4576aacc3385cc0482fca8752e8e07b54fb2696d9b12dfba2a54da346"
    sha256 cellar: :any_skip_relocation, ventura:        "076affc3b8b5309a56aa27a849e6ac7ffa7dc3c6ea7153e29183c45211d99dd6"
    sha256 cellar: :any_skip_relocation, monterey:       "c83bebea01405eda32c70d694c3195fa86c3f3f2a32ee3923454844fd5f5ff5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3c819b566fc68283182dd9c52c7978716df84d665eb10fc46400ddbfeb42d21"
    sha256 cellar: :any_skip_relocation, catalina:       "672b391318a2780fa8b5d352d4785eb652f268a8d23acb18742b6f9a29792029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "001caf95484a8f15b673838cb04fe1023ae43484c723accd5f271f072c7b7fef"
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
