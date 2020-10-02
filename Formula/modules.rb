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
    sha256 "cbc6ac501c2142c7919ecc9b56aa80d2e0828eb2c28060f792ab2d6da7947dec" => :catalina
    sha256 "5f21d6a67818b08d239fb5b530d2c82d097ea161ca17fd4b378fa63f4a50bf55" => :mojave
    sha256 "62863887e0df66d8fc99dd581a1949223d615d4bc58e4366bd0a086b42e8f94d" => :high_sierra
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
