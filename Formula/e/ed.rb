class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftpmirror.gnu.org/gnu/ed/ed-1.22.3.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ed/ed-1.22.3.tar.lz"
  sha256 "47a55ddfc52d4a1ff6f7559fbd00cf948a16b6cf151ec520392761aeae4e97be"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2ff238e53614bf352099bea5a73914bb75043db43fbdaa05fabb5400299db3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e5d7001431204df6ad18d3d65bf2c06d2151446bc615933c765f2fa292436ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf7aee2aa22ff88964a9c4455da6ef0d68df3a6efc3deeed15d0bb73169fed98"
    sha256 cellar: :any_skip_relocation, sonoma:        "287dbf1d87b97ed5e83c4d81c46aa6f61af4e26adb2c0bfcf27d8fc404acfd65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58fb7d0586d5afb68faa5d9d27c66fbb72712a4cb8ea900cdf06813a91691cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c7470aecc124a89c85243358bfee62ba0b9f81e53b256cfb8934a3e6467803"
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
