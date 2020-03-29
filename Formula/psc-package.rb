require "language/haskell"

class PscPackage < Formula
  include Language::Haskell::Cabal

  desc "Package manager for PureScript based on package sets"
  homepage "https://psc-package.readthedocs.io"
  url "https://github.com/purescript/psc-package/archive/v0.6.2.tar.gz"
  sha256 "96c3bf2c65d381c61eff3d16d600eadd71ac821bbe7db02acec1d8b3b6dbecfc"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cb82e86e3345b771e1cefa7ddc19f0a2cdad2708b9c313c0d6939d6935f68ee" => :catalina
    sha256 "bea963bcef4f13b0b43118ee5230ccc3df88fea815fcf55e455360406d5ae9a6" => :mojave
    sha256 "2254f260a569baeb84999bf42cf2ae5563dae197039a7c4c9ee6862996f2523c" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build
  depends_on "purescript"

  def install
    install_cabal_package
  end

  test do
    assert_match "Initializing new project in current directory", shell_output("#{bin}/psc-package init --set=master")
    package_json = (testpath/"psc-package.json").read
    package_hash = JSON.parse(package_json)
    assert_match "master", package_hash["set"]
    assert_match "Install complete", shell_output("#{bin}/psc-package install")
  end
end
