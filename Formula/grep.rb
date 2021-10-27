class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.7.tar.xz"
  sha256 "5c10da312460aec721984d5d83246d24520ec438dd48d7ab5a05dbc0d6d6823c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3e5e465a85b9cb0541c0344cfc9a712261f165e6415a7ea11c1cde89aeaf1551"
    sha256 cellar: :any,                 arm64_big_sur:  "af56aab63748f26589f0af9fb269df366f526ece09aee13cb73f9705a7664e25"
    sha256 cellar: :any,                 monterey:       "c71bb5fe05b6dc792ef46eb59b043651ecc6a6bcc5d87c6c529989267363887f"
    sha256 cellar: :any,                 big_sur:        "0ca6e4d8a78798fa84b9bc96be28efb0f815996a2bc3c291773467f016e874e9"
    sha256 cellar: :any,                 catalina:       "f41a618521eb9f55c50de5e6fe0c0e76df83962236cf076deff2107911fb0bdc"
    sha256 cellar: :any,                 mojave:         "180f055eeacb118cd73e2c3dbb0fda9d71fcbe0d4ee613b799a130085d6db76f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b842a12e018e675333c0cfd93602c5ef1c7889e0fa7314610182419cd73327af"
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
