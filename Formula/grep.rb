class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.8.tar.xz"
  sha256 "498d7cc1b4fb081904d87343febb73475cf771e424fb7e6141aff66013abc382"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19f74ff07a70ef50f90ce31a4f02967146469a94c2a3a4136221fc770a4a2e68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc76d72561e72794f61057e4cc0328f623a5daebfa38b8380ed24aae66e25de3"
    sha256 cellar: :any_skip_relocation, monterey:       "bc7030cf18110af5f5fc6b53bd55a0f71330c1ee69ebf4624232d26b87ca90c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "f73e2394802d0f7cd969207947b1b86d6b9e555e87260bfc2be0be141614c6fc"
    sha256 cellar: :any_skip_relocation, catalina:       "4ff6c0cb194f1358a94f694f7025f98c04ca64ec517f64994bd2b9b3e7560a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1340ba7891712b5d050abdd12de4dd8646953656d693b5080045872d3c2e5656"
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
