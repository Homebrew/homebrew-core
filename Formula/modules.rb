class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.1.3/modules-4.1.3.tar.bz2"
  sha256 "f3188dd5f642244e139c3fc6a47d59f6f6231e8c242c74ef4b1922cad2f53889"

  bottle do
    sha256 "114cc45a31e4def1cd2f2696fd3b1c2186ee40c213cf75bea851f2c8c83f03ad" => :high_sierra
    sha256 "d3905f277d578cf15ff6ce9067109a7aee8d78eab80029da676f7252d07a6bab" => :sierra
    sha256 "d3b77d5de4c9f08221797e7771061e18f76012f2cd0328b2fc2acccbbea5ca99" => :el_capitan
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
