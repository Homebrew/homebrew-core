class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.7.tar.xz"
  sha256 "5c10da312460aec721984d5d83246d24520ec438dd48d7ab5a05dbc0d6d6823c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a48ab26324b25a6033372f26490b09e7e0569f76a4b7f85bdd0aa9a3fc996537"
    sha256 cellar: :any,                 big_sur:       "6ee2dac30a5250d7d218b6520392b4cb8e7a806149f900e11637e556e6a9237a"
    sha256 cellar: :any,                 catalina:      "78c2b965ced34a99ac47d3058a3971b9696a6157215c82edd16562d6ec6fc689"
    sha256 cellar: :any,                 mojave:        "80a62eaefb57437bcb3aeb1d8489b9bf062ec77184624249da27afc578be1315"
    sha256 cellar: :any,                 high_sierra:   "ae3cfbe66d6391edd32153f9b02e3da1286482dd196a18da017903a0bd4e7cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d256494db01809327bcbe122bae1157c252084b2b42754388b675051918b2705"
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
    ]

    on_macos do
      args << "--program-prefix=g"
    end
    system "./configure", *args
    system "make"
    system "make", "install"

    on_macos do
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

    on_macos do
      grepped = shell_output("#{bin}/ggrep match #{text_file}")
      assert_match "should be matched", grepped

      grepped = shell_output("#{opt_libexec}/gnubin/grep match #{text_file}")
      assert_match "should be matched", grepped
    end

    on_linux do
      grepped = shell_output("#{bin}/grep match #{text_file}")
      assert_match "should be matched", grepped
    end
  end
end
