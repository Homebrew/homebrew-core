class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.3.tar.xz"
  sha256 "b960541c499619efd6afe1fa795402e4733c8e11ebf9fafccc0bb4bccdc5b514"

  bottle do
    cellar :any
    sha256 "053f4c07a7601f2c4b4c4c8ec71cd380d9f6bbe19853c9486fffed54626a9968" => :mojave
    sha256 "e3e994be6bbe0998b2132bd4887ece1e9ec1ab5995b40e00ab52f89fd4edf44b" => :high_sierra
    sha256 "ccae999dfa982fcafd94f710c62887ee402fb7e45b422242c7f2b6d9ba4c8f4c" => :sierra
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
