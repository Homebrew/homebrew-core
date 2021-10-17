class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.0.1/modules-5.0.1.tar.bz2"
  sha256 "b236fd0a5823091799ff98b13b6c482e8adbfff1f2e861d69f542eb9774ef4a1"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_big_sur: "fc00f6fefbed3d9e02cf6577829429da6cd65f42dc0672b480b6ee5a633cb0ba"
    sha256                               big_sur:       "c61614ac6c3fc7903748b4cf2720d7024dcf1de5d0c8ef8e6ed005f75359da2d"
    sha256 cellar: :any,                 catalina:      "b0287fc7e40fe32c6069807702f9ec881b3a152814db7d100005da6bf08ef300"
    sha256 cellar: :any,                 mojave:        "7244741217d5e4e860dea4bbe2a2a828c22ee4f44e292450acd9a9a67af523bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7afd9100bd3e96b4ad1e815467c82f46045ded65ad4bd10a8b53bcb718a6bacb"
  end

  depends_on "tcl-tk"

  on_linux do
    depends_on "less"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{Formula["tcl-tk"].opt_lib}
      --without-x
    ]

    if OS.linux?
      args << "--with-pager=#{Formula["less"].opt_bin}/less"
      args << "--with-tclsh=#{Formula["tcl-tk"].opt_bin}/tclsh"
    end

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
    shell, cmd = if OS.mac?
      ["zsh", "source"]
    else
      ["sh", "."]
    end
    output = shell_output("#{shell} -c '#{cmd} #{prefix}/init/#{shell}; module' 2>&1")
    assert_match version.to_s, output
  end
end
