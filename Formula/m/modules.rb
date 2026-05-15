class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-5.6.1/modules-5.6.1.tar.bz2"
  sha256 "5d36fd90b83a06fd3ed0ff951ab1101f22eb310fde3492f9d0455a68569abe5b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ad57749f2e5147af68bd14cb793daf5a1248a5066fabf5849bcc61eb81310b3"
    sha256 cellar: :any,                 arm64_sequoia: "73c1507d3f613e2e8f362e0fa372879c7308ff0a4da5c8c29552de478bda1541"
    sha256 cellar: :any,                 arm64_sonoma:  "4d6895e9c911eca582b3d8126621b990467b1c15949fd4047f5f06b3c77b2b3c"
    sha256 cellar: :any,                 sonoma:        "850380e3da9b8041f097dad78915d0e707bc22e926e6213a37923f6fb2203b87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a28e814c89976354ce48751ef27b4c3dc36ca7418e53490f78a8df71b49fd69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a00c5618052a36dca03fef4a0e2ca0239b98615ea959b928621bef9da92fc2c0"
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
