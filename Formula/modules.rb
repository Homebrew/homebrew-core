class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.0.0/modules-4.0.0.tar.bz2"
  sha256 "b108b9a91a6b10119a9a288fd3fba56d82a7a17b13c4bbb65b7e147933b461c4"

  bottle do
    sha256 "5f23fd8c96a6b9047747adfff0da7253f1ee2a76aba50e5207db94df0c36e1df" => :high_sierra
    sha256 "4dcf5079c561109c8ccbb83285b772a10f39527ee07f22307984b8727d103dc2" => :sierra
    sha256 "cf6c0306f9cd778d8925dd76ffed099db8dbaeabcb8d2f6b82c0d58b0c34db50" => :el_capitan
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
