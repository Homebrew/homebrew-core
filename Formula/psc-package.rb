require "language/haskell"

class PscPackage < Formula
  include Language::Haskell::Cabal

  desc "Package manager for PureScript based on package sets"
  homepage "https://psc-package.readthedocs.io"
  url "https://github.com/purescript/psc-package/archive/v0.6.2.tar.gz"
  sha256 "96c3bf2c65d381c61eff3d16d600eadd71ac821bbe7db02acec1d8b3b6dbecfc"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a75a27be86752582bcac4e48106c988a58eb3646c19c5d23f5263953fb2a0e4" => :catalina
    sha256 "d079267dd53b3d701017cca093a79a21bd4dd1bc10ea8c99bd470e98dbcae85e" => :mojave
    sha256 "18f98b6491efe2dde9bfd15fad74f6c04f247202e090f99efa7eb8a04fc1bc7f" => :high_sierra
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
