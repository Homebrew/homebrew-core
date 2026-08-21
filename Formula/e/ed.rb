class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftpmirror.gnu.org/gnu/ed/ed-1.22.6.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ed/ed-1.22.6.tar.lz"
  sha256 "3f33b22135219c39c3c695f7b7171c2567d3e2a17c798c0a90607320cbb268f2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d1b8e53901e0960e73c63de628489abf3fd0168bdcca201ef582bf10809907c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88bfdc980a1d2425920cba9fa8aa9b85ff54a3f82aeefce29d1216ff65d94616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa66fd4854a0d2c9f486ecab1e26e086d4b0c57faffa7a65720dff00998a5271"
    sha256 cellar: :any_skip_relocation, sonoma:        "9386ff506ed9243bfe18608da0abe294f8eb1dcecc88599291b35e5417db4452"
    sha256 cellar: :any,                 arm64_linux:   "2083534a9961531dc0ca3a3fb867c8a5e5a6dba75160a9ce3b9f9f9ef2156d48"
    sha256 cellar: :any,                 x86_64_linux:  "9a6a6501a78591e720edb182f23871dbd4221321a497b50754b518356ce5c1d2"
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
