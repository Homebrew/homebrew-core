class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.1.tar.xz"
  sha256 "db625c7ab3bb3ee757b3926a5cfa8d9e1c3991ad24707a83dde8a5ef2bf7a07e"

  bottle do
    cellar :any
    sha256 "8dadfa6959ee17790ef8cc578981ede226b29339549c72d26eaaa1c1dab5e0e8" => :high_sierra
    sha256 "75fd5efc0986b1771c3082e08b9dc2d8495546f81ad1a38a9a05f506c8046687" => :sierra
    sha256 "867dffadb33d24d4a743df13c95ec08ff526f3be96b4965ae5e97ec08d46192d" => :el_capitan
    sha256 "72ea449768eb5745712b40464b8eb1e7b9dc908ce26c8353e453681ee824ec89" => :yosemite
  end

  option "with-default-names", "Do not prepend 'g' to the binary"
  deprecated_option "default-names" => "with-default-names"

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

    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make"
    system "make", "install"

    if build.without? "default-names"
      (libexec/"gnubin").install_symlink bin/"ggrep" => "grep"
      (libexec/"gnubin").install_symlink bin/"gegrep" => "egrep"
      (libexec/"gnubin").install_symlink bin/"gfgrep" => "fgrep"

      (libexec/"gnuman/man1").install_symlink man1/"ggrep.1" => "grep.1"
      (libexec/"gnuman/man1").install_symlink man1/"gegrep.1" => "egrep.1"
      (libexec/"gnuman/man1").install_symlink man1/"gfgrep.1" => "fgrep.1"
    end
  end

  def caveats
    if build.without? "default-names" then <<~EOS
      The command has been installed with the prefix "g".
      If you do not want the prefix, install using the "with-default-names"
      option.

      If you need to use these commands with their normal names, you
      can add a "gnubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/gnubin:$PATH"

      Additionally, you can access their man pages with normal names if you add
      the "gnuman" directory to your MANPATH from your bashrc as well:
        MANPATH="#{opt_libexec}/gnuman:$MANPATH"
      EOS
    end
  end

  test do
    text_file = testpath/"file.txt"
    text_file.write "This line should be matched"
    cmd = build.with?("default-names") ? "grep" : "ggrep"
    grepped = shell_output("#{bin}/#{cmd} match #{text_file}")
    assert_match "should be matched", grepped
  end
end
