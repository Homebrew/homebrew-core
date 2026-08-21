class GnuWhich < Formula
  desc "GNU implementation of which utility"
  # Previous homepage is dead. Have linked to the GNU Projects page for now.
  homepage "https://savannah.gnu.org/projects/which/"
  url "https://ftpmirror.gnu.org/gnu/which/which-2.25.tar.gz"
  mirror "https://ftp.gnu.org/gnu/which/which-2.25.tar.gz"
  sha256 "1cb83e4f702e60b8211ab5ec4c2afbab1b1dec80209456a7d2faf7584ed225ea"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c60eef184cebfc5062ed02eb9e7e5ad318666427399fc1bba804831f4dac4c97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aef34aeb6d43af64a60914a19483da99bbf430107adf5668c6e77872254fdb50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fc44e542bd27b51dd2ec27b208a93f29fbcf177716fee27616ed624bb0192d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fed8cbaaf03246121a0c7b50201693894f1bfa86aef25cfe4024ac6943462708"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01024cb856e5918d9ace6d021848e8d512a24ed6a6ab77898b5430d81b143bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71ab83aed2402d38566a99d30a9421a86fb8bffac25d66f5beeac27a576c096"
  end

  def install
    ENV.append "CFLAGS", "-std=gnu17" if DevelopmentTools.clang_build_version >= 1700

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gwhich" => "which"
      (libexec/"gnuman/man1").install_symlink man1/"gwhich.1" => "which.1"
      (libexec/"gnubin").install_symlink "../gnuman" => "man"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "which" has been installed as "gwhich".
        If you need to use it as "which", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    if OS.mac?
      system bin/"gwhich", "gcc"
      system opt_libexec/"gnubin/which", "gcc"
    else
      system bin/"which", "gcc"
    end
  end
end
