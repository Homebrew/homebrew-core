class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.0.0/modules-4.0.0.tar.bz2"
  sha256 "b108b9a91a6b10119a9a288fd3fba56d82a7a17b13c4bbb65b7e147933b461c4"

  bottle do
    rebuild 1
    sha256 "afe435544abcc2afeb11daadf8bf0c6aaa0e02c8c4d9c5e551492162815f1530" => :high_sierra
    sha256 "ffadd406acde1d6504f0ce6c88cf126018949981f9848a2ce64fb9d5f1461b44" => :sierra
    sha256 "bc0333898b9c4a145bb648ec7759cc2f4082d37543b8a64abbea735cfe8fb393" => :el_capitan
  end

  depends_on "coreutils" => :build # assumes GNU cp options are available
  depends_on :x11 => :optional

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"

    # -DUSE_INTERP_ERRORLINE fixes
    # error: no member named 'errorLine' in 'struct Tcl_Interp'
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework
      --datarootdir=#{share}
      --disable-versioning
      CPPFLAGS=-DUSE_INTERP_ERRORLINE
    ]
    args << "--without-x" if build.without? "x11"
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
