class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.6.0/modules-4.6.0.tar.bz2"
  sha256 "616f994384adf4faf91df7d8b7ae2dab5bad20d642509c1a8e189e159968f911"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "d424799ee3a971d0330ac8247782fd8a3c2fc6ddbf40c743249d643128bf8c9e" => :catalina
    sha256 "fbe7043ec34d578b42ab10dba769b594d19c9d5665b1f27060fdd3a8982cefcd" => :mojave
    sha256 "688cc5ba060e509134a35d057077c022b2e9d5451e988b46c239dde24934e5f7" => :high_sierra
  end

  def install
    args = %W[
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
