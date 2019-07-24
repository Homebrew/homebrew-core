class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.2.5/modules-4.2.5.tar.bz2"
  sha256 "f9f898d489d18fb1a9637a15e7c036a75549b3a8b3716cd70c2dff1c80ef53c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "6704ca06536aaa7b15d6f4b7a44a697e5e264585d0725f9a7a2add96699e420e" => :mojave
    sha256 "d3f08b74c54724430e0bf0b9bbbff9c1eeb1c22b98b14c9d4d3221c8ae2d4161" => :high_sierra
    sha256 "6c639f39e28ad98625f59540125fda9e86f4241ecdaa1d957b5f2ec413d014b0" => :sierra
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
