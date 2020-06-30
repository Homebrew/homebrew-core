class NdkPkg < Formula
  desc     "Package manager for Android NDK"
  homepage "https://github.com/leleliu008/ndk-pkg"
  url      "https://raw.githubusercontent.com/leleliu008/ndk-pkg/master/ndk-pkg-0.1.0.tar.gz"
  sha256   "e041c4e3fd2bb4e3d8c6a61f3ef81581c7444bd919a1a3ac5c6279e13b44e9ce"
  head     "https://github.com/leleliu008/ndk-pkg.git"
  depends_on "curl"

  def install
    bin.install "ndk-pkg"
    zsh_completion.install "zsh-completion/_ndk-pkg" => "_ndk-pkg"
  end

  test do
    system "#{bin}/ndk-pkg", "--help"
  end
end
