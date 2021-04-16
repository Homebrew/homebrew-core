class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.7.1/modules-4.7.1.tar.bz2"
  sha256 "a6ab006ccc176ddc5b92659119be68563641fa15d72c518b97becba9f11e201f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256               arm64_big_sur: "8cc933f4ad6ffd306c36f080228d326181ac471e56b92e0c32c75e2c3e95eb9b"
    sha256               big_sur:       "5d63553037af74beab1d31831b3880622eb2bdf4e981ac67ba20afbfc7b33b02"
    sha256 cellar: :any, catalina:      "a6257daf6e36156bc6bbde38622778b2b3dabe4681eead1fd238e3aa7b5a71e9"
    sha256 cellar: :any, mojave:        "9a2dc8c4e84f0c33dfa5c60210fd5716a5f087f5c0624bfd4ad3e6e492bff19b"
  end

  depends_on "tcl-tk"

  def install
    args = %W[
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{Formula["tcl-tk"].opt_lib}
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
