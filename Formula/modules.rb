class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.1.0/modules-4.1.0.tar.bz2"
  sha256 "b83733168ca3fe952cef685fe0d4fdd561685e0ef8c8d02b4c9b4415bf1312ab"

  bottle do
    sha256 "293e90e75239faff2658297940f1ed30dc3664a9a081299ad933a97ca49e652c" => :high_sierra
    sha256 "153168521e2b05146de915ccf46fc031a4a965cdba14ddcdf5200645211b14c0" => :sierra
    sha256 "fbcf6e89165b5d0c56a6f27e4e5fd23d0a369f16a0028feed1a4051adea692af" => :el_capitan
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
