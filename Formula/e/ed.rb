class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftpmirror.gnu.org/gnu/ed/ed-1.22.5.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ed/ed-1.22.5.tar.lz"
  sha256 "56e107ddc2f29dad6690376c15bf9751509e1ee3b8241710e44edbe5c3a158cc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80b2d6d72abc4010a156e6deba62553dd617df431c09afb1b47716bc8a5b3d7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2be3e0854f079a026ce53c25d6071128f3eef8adb8429eac333aa94a1e88b4c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d3c9641f3def99e02c845c46af7bf61dcc6643c8cf3d88116ca7687e6ad8963"
    sha256 cellar: :any_skip_relocation, sonoma:        "72f5ff75a704c662101223a085c6af24941c68212c64e0ce9a3e675bb710cfbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae82ddc23421a1b75370233b72b5e5ae5cf11814f28d7e7c36cb5161c0968f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aafcf322545be9737d4169d9556998e79b67ba84d0ed77dc10a7ed53149bcb1"
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

    (libexec/"gnubin").install_symlink "../gnuman" => "man"
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
