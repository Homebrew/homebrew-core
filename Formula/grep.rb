class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.9.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.9.tar.xz"
  sha256 "abcd11409ee23d4caf35feb422e53bbac867014cfeed313bb5f488aca170b599"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ffc7c2c2921571cfaae661324457dcb790b711f256068036e6184befd429f743"
    sha256 cellar: :any,                 arm64_monterey: "33a5787d66a9ad255709ff63050a1d17412c141dcea67a25d795d04bd63fc25e"
    sha256 cellar: :any,                 arm64_big_sur:  "6a26b928f5e92fff54f80702262f7b795c7cc18bf3c2eee83e6663b12f42a4aa"
    sha256 cellar: :any,                 ventura:        "59dad9859bafb8db1936a651893f4fb326c46be7b07c1a7bc36216838cdbc293"
    sha256 cellar: :any,                 monterey:       "53f8b2875abb875238699bf0355ea0c55e2518a59245decd5513ea3b5889470b"
    sha256 cellar: :any,                 big_sur:        "91356bbe4b7d19fae8ffb73b16852e607e20029dafad426e98c860d4f4a91f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b7660ceb6d9ab33bcc705e4c7fc08a2cc1f394019a42059ed2b6d7ed935069c"
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
