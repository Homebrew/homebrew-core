require "language/haskell"

class PscPackage < Formula
  include Language::Haskell::Cabal

  desc "Package manager for PureScript based on package sets"
  homepage "https://psc-package.readthedocs.io"
  url "https://github.com/purescript/psc-package/archive/v0.6.0.tar.gz"
  sha256 "71815aedaac2d27267e5ec235805583a774c09aaf9e00ef5add74475587b3ef6"

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
