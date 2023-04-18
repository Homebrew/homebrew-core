class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.2.0/modules-5.2.0.tar.bz2"
  sha256 "65f6537e770c66036c8adcad57c51a389f805d19fe942c963bd9f29337832b6e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "28f48e73799b77fc44482be6a3e36f6078d54deb13140611fd9d8455444e6d29"
    sha256 cellar: :any,                 arm64_monterey: "791424338ae1b6512e57fec61ebf175961c6efc323b310742e860f569fe8500f"
    sha256 cellar: :any,                 arm64_big_sur:  "5d1a9750b042c2b6a24712d68be78d0ef7522ef1b2244efbb717cd948220a2db"
    sha256 cellar: :any,                 ventura:        "dd049ee6b80b34148d5dcb69c9d78d7a7089cf120d32b67f5c2d7fedab220e57"
    sha256 cellar: :any,                 monterey:       "0b48ad16c1b83bf9067e609ed9d85284d2529e652a8783eaacd41cf75706e3ac"
    sha256 cellar: :any,                 big_sur:        "ce1a177c6cb3ee5cb42943d67038902c8a597111801a8f1e67d9257ef1398672"
    sha256 cellar: :any,                 catalina:       "1db25335f94079e82f9992efb2c2ff92cac93a848ca36f3ba3a30f86ac024bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f71aacad8abf8e5e3d40310cd00bb305a3363d57796c07704d593a6a420db65d"
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
