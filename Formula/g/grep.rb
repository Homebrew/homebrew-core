class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.11.tar.xz"
  sha256 "1db2aedde89d0dea42b16d9528f894c8d15dae4e190b59aecc78f5a951276eab"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0c5a74551504781dec17477fd6a7ec21680c3b30be3f421d02e4f57593181ad2"
    sha256 cellar: :any,                 arm64_ventura:  "9c67868f89e03cc3ad77d4bf39c0593cf7c59d453ad8224e9c7007b800642f53"
    sha256 cellar: :any,                 arm64_monterey: "8d1835e0b36b0c644660af9515c1973d650dfffaea08ba0c42914c99c3724d1c"
    sha256 cellar: :any,                 arm64_big_sur:  "fb7628adb948252d44148389af10a0fb8d5b4c43b60cee093ebd821f678bfada"
    sha256 cellar: :any,                 sonoma:         "8a2920cc2deb14480b0195d267443839941e0e301f6fe44adc31d79a6214708b"
    sha256 cellar: :any,                 ventura:        "199c241e41de52e21ca6c28735cbbbe3e9e0595082e6742db76726f41baab11f"
    sha256 cellar: :any,                 monterey:       "e66f574af6ce36a8bcac7fd7b3d1beb9962e9af570ccb04c7ed916cd04e9017b"
    sha256 cellar: :any,                 big_sur:        "bbcc7e67bfdf6f9d89dfed9895e52620c88717d3e917e5c8fed35790a611069e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caca59a561720fc8d5c57c39d1272c236e147e33ca8d66b2defb1e46466a29ff"
  end

  head do
    url "https://git.savannah.gnu.org/git/grep.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "texinfo" => :build
    depends_on "wget" => :build

    uses_from_macos "gperf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "pcre2"

  def install
    system "./bootstrap" if build.head?

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
