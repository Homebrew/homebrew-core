class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.5.0/modules-5.5.0.tar.bz2"
  sha256 "cb6355b0c81566a4d3ecd06fb4ae6afc9665a087b1e9039c5b5ffbc46fa282e2"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5ee8c71190aeced9c34d24f7b6390cfa0bf50b956a5a2290ee551b01c9aa1086"
    sha256 cellar: :any,                 arm64_sonoma:  "86119337a0e011b3caf42509870164f5066f0c75089998113da9c0f06125e8c4"
    sha256 cellar: :any,                 arm64_ventura: "9de919dfb835f533aed25bf0c0b0136c910e7d630b932b38254c27570315b578"
    sha256 cellar: :any,                 sonoma:        "aebb442a0032596c907ffc37e7a18c277ca3573d1cca286672082fb6854e49f5"
    sha256 cellar: :any,                 ventura:       "384d55d505817dec102466f81f646fdb554d9736a0259f806a29743b88f0c332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da598032599f2d8333a49d29652dadad9aaa674ea502eeeccfd33bb822414cc8"
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
    args << "--with-pager=#{Formula["less"].opt_bin}/less" if OS.linux?

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
