class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.3.1/modules-5.3.1.tar.bz2"
  sha256 "171f7faebc1363c8738a6905b31074636dd81d303098002b1c25801ee5483d86"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "539114dd953441f82633f0f5ce201719c7d5ffda9613ec94702997a08e774e84"
    sha256 cellar: :any,                 arm64_monterey: "82afee11869c89ee190f3fc6980f2c3acb543f4020ef49389f444948f8ae3146"
    sha256 cellar: :any,                 arm64_big_sur:  "1943734262bd565d5a170208a3aa3a14945342a440043e63051ddf66e1597a91"
    sha256 cellar: :any,                 ventura:        "343d1394d56a919042afad951b2e43c18687d6b0132844e2d5ac07269211b3e0"
    sha256 cellar: :any,                 monterey:       "fe91df353c52b0456323d366f55fb9d6eda624b868439bcf28407453412b1b6f"
    sha256 cellar: :any,                 big_sur:        "cfc7cf47d087751ed1fe11735ad56ae11d0cf61f64bea4d39ba12c3fca74046a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d96274b4f7ea6077d0d72bfee2c769ef0cc455cda316c321b522825936d57da5"
  end

  depends_on "tcl-tk"

  uses_from_macos "less"

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
