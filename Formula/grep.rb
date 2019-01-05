class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.3.tar.xz"
  sha256 "b960541c499619efd6afe1fa795402e4733c8e11ebf9fafccc0bb4bccdc5b514"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0f08d2cc274d9be9d21208eae8a5022cd2dc49690da229353238fcf48dacb3af" => :mojave
    sha256 "d193e844ebfcf6945e52735980903ba02772433479da9644121aacad7cc4cbe8" => :high_sierra
    sha256 "70b7852cf5377d64dc8523c861a5536f0d1cf096aef27682c21a49bdb08087be" => :sierra
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
  end

  def caveats; <<~EOS
    All commands have been installed with the prefix "g".
    If you need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:
      PATH="#{opt_libexec}/gnubin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "gnuman" directory to your MANPATH from your bashrc as well:
      MANPATH="#{opt_libexec}/gnuman:$MANPATH"
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
