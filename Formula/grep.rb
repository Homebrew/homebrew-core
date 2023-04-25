class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.10.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.10.tar.xz"
  sha256 "24efa5b595fb5a7100879b51b8868a0bb87a71c183d02c4c602633b88af6855b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8e444201a879d84ffb727f1d325365847b3db0fa60624a3a91eedfd614268cff"
    sha256 cellar: :any,                 arm64_monterey: "8525bd8ca3124807057fca7af09c8d2ed971d95c020c4efbf56e6332d7044358"
    sha256 cellar: :any,                 arm64_big_sur:  "b4766c21c402a8404d42e60264de48b654c0505654cb8e4559530f417194764e"
    sha256 cellar: :any,                 ventura:        "30e1ff24dec06dd3762aca18668678916d6fd6d7f4120979e6d8b889bed0f519"
    sha256 cellar: :any,                 monterey:       "0e057d1efa81c0fbe4b2066d8f17eb8d601609db5df67f8df2e11bf824dc242b"
    sha256 cellar: :any,                 big_sur:        "79ee020a878839ef1f82011c3920740de41dab1d836d103b7f6578ab9be60b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0ab17147739106c7bd0360ddce18374025f37ea5e8badf2df1010774046def8"
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
