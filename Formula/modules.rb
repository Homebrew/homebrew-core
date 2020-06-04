class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.5.1/modules-4.5.1.tar.bz2"
  sha256 "8d9829905f79d379c2cf753c7fe6f7be1188853e859f81b44f5116337e8f49d9"

  bottle do
    cellar :any
    sha256 "dc8e1339ea1fa2265c680c0a29e96cb9b3dbdcc7ce789e3708989ed1ccfd3af5" => :catalina
    sha256 "6ac40d686f229d8374e185a1487551a84c6fba4a71c37d319cbd5e44051ed869" => :mojave
    sha256 "af783a47bae2302f93142b1980ba3d05b49583c28b0ddf71dcc6dbf9c2705cd5" => :high_sierra
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

  def caveats
    <<~EOS
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
