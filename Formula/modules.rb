class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.1.4/modules-4.1.4.tar.bz2"
  sha256 "7eaf26b66cbf3ba101ec5a693b7bfb3a47f3c86cad09e47c4126f3d785864c55"

  bottle do
    sha256 "1bfdf504b019fa4c8ffe7db7d9cef79a1a2c23e381b04d7eed98f041b3507987" => :mojave
    sha256 "29eacb986d942b621d5aa161952c962250cc6d96acb9929425d8a5284f7a6ca2" => :high_sierra
    sha256 "4e45ab192bad2a47c3b63e7de10d61c701a1f8a70a011956b21203074dee8418" => :sierra
    sha256 "b3a8d7c48c0b6c56a706357da2a0b6087c593f2254acd7b84956e6870053b8e1" => :el_capitan
  end

  depends_on "grep" => :build # configure checks for ggrep
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
