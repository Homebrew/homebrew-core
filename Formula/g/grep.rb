class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.11.tar.xz"
  sha256 "1db2aedde89d0dea42b16d9528f894c8d15dae4e190b59aecc78f5a951276eab"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "f2d782119a8db8dadbe269fba01347bed05437ef29ea8b9acff4eb86c005838b"
    sha256 cellar: :any,                 arm64_ventura:  "7740686659769c3287bce39bfd85026036a7b3b039ec52db00907be4242c0851"
    sha256 cellar: :any,                 arm64_monterey: "2e69dd6b69142d2dc6ca4d4e91ddcea5116ba4e41aaa9e7e3bde27aa9e21bed4"
    sha256 cellar: :any,                 sonoma:         "2bd0cc20cf4441fb63e49124481136171621c6f4f2ca3e9931183b59987b6962"
    sha256 cellar: :any,                 ventura:        "ab101c3e829af315e8ae02089972c810a3feb93c186636e61f1eb298f67617d0"
    sha256 cellar: :any,                 monterey:       "272a64291286beca18b8b3206e8450fe82527b44d5137c6031127921bd5ce2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f09ff52572870c0f82179c48996f615090d6c84d2f10873a1f0d71132a6b6149"
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
      bin.children.each do |file|
        (libexec/"gnubin").install_symlink file => file.basename.to_s.delete_prefix("g")
      end
      man1.children.each do |file|
        (libexec/"gnuman/man1").install_symlink file => file.basename.to_s.delete_prefix("g")
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
