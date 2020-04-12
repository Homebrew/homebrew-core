class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.5.0/modules-4.5.0.tar.bz2"
  sha256 "9f2a12bf2f32ff69148117bb154d17c3e6b9b816c4907fef7127d65ce60f1c73"

  bottle do
    cellar :any
    sha256 "0c7b11dae0311e6f6f4f97981f01baf80086d1ec1101a045ae834b8410002038" => :catalina
    sha256 "300b211f01eb7db1ae80bd74f5de3711ac4b856159dacb1de2758ea6f831710f" => :mojave
    sha256 "86e28621fc7fb9b35fb9b4f82616ec31190ba7bbbb0a096d288ae79cd485c01c" => :high_sierra
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
