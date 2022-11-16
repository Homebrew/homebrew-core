class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.8.tar.xz"
  sha256 "498d7cc1b4fb081904d87343febb73475cf771e424fb7e6141aff66013abc382"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d2450448352fb2c389634cab3dec581882f6fc0f02a79489b4ba9c603b8f780b"
    sha256 cellar: :any,                 arm64_monterey: "2a97d1431a8c367299b3ec1a62836136ad0474f78bd515f29b2210cc85591a66"
    sha256 cellar: :any,                 arm64_big_sur:  "b23c8e00f85e4a10c1827619248a117ab2df3bd1503b5191c4467533fd299bec"
    sha256 cellar: :any,                 ventura:        "d0d9b98da7b6eedb0d08d0b73e4dfd0627f5f3d19a3b850e248d33f6d13f039e"
    sha256 cellar: :any,                 monterey:       "5b13dfd3339908dedfb233c3ba77a45fff7f55569b9252979349eb7fb0a45b5a"
    sha256 cellar: :any,                 big_sur:        "f3b4b34263e59e4dfe427381ddecb820189f8336c464d97e5ab4e8b624d65484"
    sha256 cellar: :any,                 catalina:       "bbb952d77089ccca022c170c295b48dea9d5afc90c3da65ee447adb04593c2c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f771443ddfadac7158cd0bb2f4f1e682a2cc9b69e99c8ed0f77e41f546838067"
  end

  depends_on "pkg-config" => :build
  depends_on "pcre2"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
      --infodir=#{info}
      --mandir=#{man}
      --with-packager=Homebrew
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make"
    system "make", "install"

    if OS.mac?
      %w[grep egrep fgrep].each do |prog|
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
    text_file = testpath/"file.txt"
    text_file.write "This line should be matched"

    if OS.mac?
      grepped = shell_output("#{bin}/ggrep -P match #{text_file}")
      assert_match "should be matched", grepped

      grepped = shell_output("#{opt_libexec}/gnubin/grep -P match #{text_file}")
    else
      grepped = shell_output("#{bin}/grep -P match #{text_file}")
    end
    assert_match "should be matched", grepped
  end
end
