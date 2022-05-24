class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.1.0/modules-5.1.0.tar.bz2"
  sha256 "0fe84ee80f7470b5e6bd339bc04c464f06e2db4b5859b4ebd2847a84e9217e1c"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_monterey: "334f813c5fcbf50c3f35f26a3fe6ad57e28d0277ea7d164570ccb3c719ec1680"
    sha256                               arm64_big_sur:  "31b0d3ffc6aa3d331c3af1b7f9a5b44156f8756e21d6cc4beb966090d7e4bbd7"
    sha256                               monterey:       "3586ebf3ff07fccf4b7663790ef0065ed8b714c95206b46d5ee5f3cf89b1fc7e"
    sha256                               big_sur:        "5922381d6e9fcd567c4af9d599683601107984e1c538bd348b83e375a448cb2d"
    sha256 cellar: :any,                 catalina:       "e5371939e1b942bcd7d968e2349faf9ba892aa8666975f1ab0875543b8b4c5cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527235069a340ba96eaddff6e456038157174b5de68192438b0f1489526d1201"
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
