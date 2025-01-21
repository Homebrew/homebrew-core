class Gpatch < Formula
  desc "Apply a diff file to an original"
  homepage "https://savannah.gnu.org/projects/patch/"
  url "https://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/patch/patch-2.7.6.tar.xz"
  sha256 "ac610bda97abe0d9f6b7c963255a11dcb196c25e337c61f94e4778d632f1d8fd"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa12158f8c8c19015ba6569e1b2395d071520b8d2d8cc5155cfcdfcbc50f09b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8417fef3457d9cb9a09d0bdaa40ddd6c867ea30a597fc668808486e1135e641"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bac8e7a0b6b1862a61bc686ab6df327c3eede8c28bd524127ed1b45000ecb1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4d79d31ed845a3389abd1e7e8d59d62544f6371348d22592ec95e28023ef446"
    sha256 cellar: :any_skip_relocation, ventura:       "bb8c06471dbfa2cf24efa88eaede791bd8f4d39ea5f08e5b92b38108e54b5c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f10fc17d95257c9de34edf1ea0a8d852a41cc6f7d5bbb18d62c75d7a295469f9"
  end

  def install
    args = std_configure_args
    args << "--program-prefix=g" if OS.mac?

    system "./configure", *args
    system "make", "install"

    return unless OS.mac?

    # Symlink the executable into libexec/gnubin as "patch"
    (libexec/"gnubin").install_symlink bin/"gpatch" => "patch"
    (libexec/"gnuman/man1").install_symlink man1/"gpatch.1" => "patch.1"
    (libexec/"gnubin").install_symlink "../gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "patch" has been installed as "gpatch".
        If you need to use it as "patch", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    testfile = testpath/"test"
    testfile.write "homebrew\n"
    patch = <<~EOS
      1c1
      < homebrew
      ---
      > hello
    EOS
    if OS.mac?
      pipe_output("#{bin}/gpatch #{testfile}", patch)
    else
      pipe_output("#{bin}/patch #{testfile}", patch)
    end
    assert_equal "hello", testfile.read.chomp
  end
end
