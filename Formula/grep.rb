class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.4.tar.xz"
  sha256 "58e6751c41a7c25bfc6e9363a41786cff3ba5709cf11d5ad903cf7cce31cc3fb"

  bottle do
    cellar :any
    sha256 "52fb744dfc1f2766b41d90bc4126bc6101663d12c3e31446719ef723b7883266" => :catalina
    sha256 "cbce0c10ed3edc352347287ec36a8a199bb7649892943a6948e4dbe4127e83ac" => :mojave
    sha256 "bcc9802f916e1db94b2879ff66b058d42142b391bfbc2002fd1fb13fd9e4c8ca" => :high_sierra
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
