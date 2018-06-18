class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.1.3/modules-4.1.3.tar.bz2"
  sha256 "f3188dd5f642244e139c3fc6a47d59f6f6231e8c242c74ef4b1922cad2f53889"

  bottle do
    sha256 "3ae66f974cb5d829374813f56e0c4d94bf77a09e1d2e15579b5fbc9d3bd6ddd2" => :high_sierra
    sha256 "703c6305675950d51a35f08a072aff0aa3f453f65e9beb129e1b5345873e6e4c" => :sierra
    sha256 "65aad67d21baa8a0d77b6efb141a418b9a5e5feeb1eed0507160adf799fd8a23" => :el_capitan
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
