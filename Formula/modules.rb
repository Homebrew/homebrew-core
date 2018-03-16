class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.1.1/modules-4.1.1.tar.bz2"
  sha256 "63ba8dacafa42ccebebe5d518e2be3b6b3683b9e384ab756133cc6d1d4d8f214"

  bottle do
    sha256 "d3fe866d8837a344b2b716ee60c3b58eab43d33f1231be08f0148636fe5da299" => :high_sierra
    sha256 "1956c56f45992bdb7ef63ead14b780da874d9f474cccbb136cec662432b72470" => :sierra
    sha256 "f5a161686c6217bedea75dc0d21a277414232d569feaf48cb6fbf1dd430ffbd4" => :el_capitan
  end

  depends_on "coreutils" => :build # assumes GNU cp options are available
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
