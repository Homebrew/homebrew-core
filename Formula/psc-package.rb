class PscPackage < Formula
  desc "Package manager for PureScript based on package sets"
  homepage "https://psc-package.readthedocs.io"
  url "https://github.com/purescript/psc-package/archive/v0.6.2.tar.gz"
  sha256 "96c3bf2c65d381c61eff3d16d600eadd71ac821bbe7db02acec1d8b3b6dbecfc"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54f1d5c06e4c59a36e9cd96aa826dce5fce68e13d3cd6572ded1133b90d26fde"
    sha256 cellar: :any_skip_relocation, big_sur:       "4102b38df638a4defcf0f1ef857b419ae7cddd15605d6921a2d831e8d4f7fa5e"
    sha256 cellar: :any_skip_relocation, catalina:      "f5baac6c49a67991b2ed0f2a2ba34898317e9cfd6864e8b446fb159f80ae04ec"
    sha256 cellar: :any_skip_relocation, mojave:        "e6cd795e5eade3414e2149f4fe4d529468293b122659ed5bd8b2b4df716c77cf"
    sha256 cellar: :any_skip_relocation, high_sierra:   "0b0411dfd516bac15b2e99cba163dbc3c77742eae9e09038ac85ef1793ce767c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a14a1778082c9aa6660a4a518d6c093a6b99c46c9965d8b8000390823193bcbc"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "purescript"

  # Apply upstream patch to fix build. Remove with next release.
  patch do
    url "https://github.com/purescript/psc-package/commit/2817cfd7bbc29de790d2ab7bee582cd6167c16b5.patch?full_index=1"
    sha256 "e49585ff8127ccca0b35dc8a7caa04551de1638edfd9ac38e031d1148212091c"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "Initializing new project in current directory", shell_output("#{bin}/psc-package init --set=master")
    package_json = (testpath/"psc-package.json").read
    package_hash = JSON.parse(package_json)
    assert_match "master", package_hash["set"]
    assert_match "Install complete", shell_output("#{bin}/psc-package install")
  end
end
