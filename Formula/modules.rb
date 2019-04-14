class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.2.3/modules-4.2.3.tar.bz2"
  sha256 "83a4afdd3784278cb86aa3fbf82bcda8fea46b12fae616d865cfe7e8d357e4ac"

  bottle do
    sha256 "1bfdf504b019fa4c8ffe7db7d9cef79a1a2c23e381b04d7eed98f041b3507987" => :mojave
    sha256 "29eacb986d942b621d5aa161952c962250cc6d96acb9929425d8a5284f7a6ca2" => :high_sierra
    sha256 "4e45ab192bad2a47c3b63e7de10d61c701a1f8a70a011956b21203074dee8418" => :sierra
    sha256 "b3a8d7c48c0b6c56a706357da2a0b6087c593f2254acd7b84956e6870053b8e1" => :el_capitan
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework
      --without-x
    ]
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<~EOS
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
