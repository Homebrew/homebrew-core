class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.3.0/modules-4.3.0.tar.bz2"
  sha256 "3a33ab5ca9f43b12491896859bb812721c5dc4bd7500fce35a51a802760cec49"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca75f7d31f9698e69d0f89d7b99474dba36c73c67fc698f29e8af78a18d92cbb" => :mojave
    sha256 "8d3e5a0ebb734938a32fd734e49c8bc258c64a753327a312a1a5a8d78bc2f4b6" => :high_sierra
    sha256 "9b402a25481669f3d92d900249dc8741ef5bce5d6ad8b64a9e8efa342572e814" => :sierra
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
