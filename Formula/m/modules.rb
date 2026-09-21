class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.6.2/modules-5.6.2.tar.bz2"
  sha256 "9c3407ca815004db0ee3782a7d4cba2a8907aff25b1dee108d9ac361c78964e2"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d2dca6e16ad0ea1355127b2c5b9cb761b14145bd990538c7ff5c20faede439d3"
    sha256 cellar: :any, arm64_tahoe:       "bf7016ad8edff7c651260461d986457389c16abbec7a1693dcac9c3c98583458"
    sha256 cellar: :any, arm64_sequoia:     "730a2b05a9579e0134d84c4f245af1edab652e78dee2197d57727693d71a1c8a"
    sha256 cellar: :any, arm64_sonoma:      "b64587cd90ae1683647a229ccd885b6196d1179c998bace1acc6300c2e350792"
    sha256 cellar: :any, arm64_linux:       "fd50dbe5b15ffbfa7f5121d6d00b8335c870dd26c16a63e69dafa522251e7a72"
    sha256 cellar: :any, x86_64_linux:      "c0c200e124beea902fd55d799aa2be6c329842e3e2944b4cd6c5e5f41f1a9714"
  end

  depends_on "tcl-tk"

  uses_from_macos "less"

  def install
    tcltk = Formula["tcl-tk"]
    args = %W[
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{tcltk.opt_lib}
      --with-tclsh=#{tcltk.opt_bin}/tclsh
      --without-x
    ]
    args << "--with-pager=#{formula_opt_bin("less")}/less" if OS.linux?

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To activate modules, add the following at the end of your .zshrc:

        source #{opt_prefix}/init/zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    assert_match "restore", shell_output("#{bin}/envml --help")
    shell, cmd = if OS.mac?
      ["zsh", "source"]
    else
      ["sh", "."]
    end
    output = shell_output("#{shell} -c '#{cmd} #{prefix}/init/#{shell}; module' 2>&1")
    assert_match version.to_s, output
  end
end
