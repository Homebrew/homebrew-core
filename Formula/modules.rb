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
    sha256                               arm64_monterey: "a136b5b82c0273c00efbd4485fb9b7c203778daa7798caed460387b3303bca9b"
    sha256                               arm64_big_sur:  "99989d4c1b3bd3ea7917046ace4d54d3184d8bec4ff82145f5f6bb2a17444c78"
    sha256                               monterey:       "798d7f1208a0552e2a0fa874aa0506fd36557abe1ffcec123d28070c10392f27"
    sha256                               big_sur:        "c30c9be63dc8fc0f8d83ef063e56c6d459b8ded76e51f8b76ce90a48f89124f8"
    sha256 cellar: :any,                 catalina:       "32433c130fc3615af0fe6013201486f02cadfbaebf3af8dbf45bccf7f3942cc4"
    sha256 cellar: :any,                 mojave:         "c66463bc0006612e617657bc194d588f1f054196e4ab5a5b94078a0105482c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59fd50c28a705deaf3ffb014e816ff6bc50877757134a0509cc11db4546cd79d"
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
