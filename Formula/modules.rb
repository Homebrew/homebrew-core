class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.7.0/modules-4.7.0.tar.bz2"
  sha256 "68099b98f075c669af3a6eb638b75a2feefc8dd7f778bcae3f5504ded9c1b2ca"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256               arm64_big_sur: "9efa2847cd3b742278569de48251e6e4a3828a4faaee55621c399f8d01efe5ed"
    sha256               big_sur:       "637ca6ff4592b1c2392a927f289bdb8d867d922f90a9df91aed57c45d6c1d1d4"
    sha256 cellar: :any, catalina:      "768a0050642449eea6a5d714e39a83f23ca32b2e19a8f3c15e29a75854aebf55"
    sha256 cellar: :any, mojave:        "9778d58e3a2f1a41236f26c634e75062c1b2c2be2569c65e758c2226a81a0463"
  end

  depends_on "tcl-tk"

  def install
    args = %W[
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{Formula["tcl-tk"].opt_lib}
      --without-x
    ]
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To activate modules, add the following at the end of your .zshrc:
        source #{opt_prefix}/init/zsh
      You will also need to reload your .zshrc:
        source ~/.zshrc
    EOS
  end

  test do
    assert_match "restore", shell_output("#{bin}/envml --help")
    output = shell_output("zsh -c 'source #{prefix}/init/zsh; module' 2>&1")
    assert_match version.to_s, output
  end
end
