class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.6.tar.xz"
  sha256 "667e15e8afe189e93f9f21a7cd3a7b3f776202f417330b248c2ad4f997d9373e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "9d3347c001171d788a12d0113de23d347722a0587ae27540aa01afb32d95aa3a" => :catalina
    sha256 "6c8b53ccc62d1dc82c07f4758909d74be944f2f2770fd3a147660a70a78b95e7" => :mojave
    sha256 "62f85b85c25c50ac0899a16fc83945f4361db6e4c8beae0e44d4a9f748291622" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
      --infodir=#{info}
      --mandir=#{man}
      --with-packager=Homebrew
      --program-prefix=g
    ]

    system "./configure", *args
    system "make"
    system "make", "install"

    %w[grep egrep fgrep].each do |prog|
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
    text_file = testpath/"file.txt"
    text_file.write "This line should be matched"

    grepped = shell_output("#{bin}/ggrep match #{text_file}")
    assert_match "should be matched", grepped

    grepped = shell_output("#{opt_libexec}/gnubin/grep match #{text_file}")
    assert_match "should be matched", grepped
  end
end
