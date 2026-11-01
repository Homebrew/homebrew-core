class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.7.0/modules-5.7.0.tar.bz2"
  sha256 "3e3cc7582ea34f3cf8353152fae724dea00dc893f021080263f475dcaeb40520"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f576e16b0001fe35da4b63000582a18a0120c91b7154d01397e58354aae40fc2"
    sha256 cellar: :any, arm64_tahoe:       "15d5c0388d4f43239ef034f5547902395b514c304e1fbd8fcc257287f66bd212"
    sha256 cellar: :any, arm64_sequoia:     "0aa6131d168592dfac4877a4ded5a1183692f5cad9f3adce13083c6ba99189e7"
    sha256 cellar: :any, arm64_linux:       "53393cbf8232d697094bc67c0c053356deead6a1aefcb80753b2cb4e217a808c"
    sha256 cellar: :any, x86_64_linux:      "a9d2cfc5e7a5f40f336328d268b5fdcfd388d76eb7b882086df87549e8e4bd30"
  end

  depends_on "tcl-tk"

  uses_from_macos "less"

  deny_network_access!

  def tcltk = deps.map(&:name).find { |d| d.match?(/^tcl-tk(@\d+(\.\d+)*)?$/) }

  def install
    args = %W[
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{formula_opt_lib(tcltk)}
      --with-tclsh=#{formula_opt_bin(tcltk)}/tclsh
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
