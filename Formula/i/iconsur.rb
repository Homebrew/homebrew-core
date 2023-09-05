require "language/node"

class Iconsur < Formula
  desc "macOS Big Sur Adaptive Icon Generator"
  homepage "https://github.com/rikumi/iconsur"
  url "https://registry.npmjs.org/iconsur/-/iconsur-1.7.0.tgz"
  sha256 "d732df6bbcaf1418c6f46f9148002cbc1243814692c1c0e5c0cebfcff001c4a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c89a0bafa76e65252ca37540e7e80079894ef63150c4d29fdbaa2f92ce04359"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "304d38f9248f8979b2b483280cac76690c14b61ff87f08484c0dc2a9387c21b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "304d38f9248f8979b2b483280cac76690c14b61ff87f08484c0dc2a9387c21b8"
    sha256 cellar: :any_skip_relocation, ventura:        "eaf5ee9a4bc080056cf6ea44e633660b90309b201d17b4b7165eaa3e62656d63"
    sha256 cellar: :any_skip_relocation, monterey:       "77884a43974a1b6a917d415b12d2b6fe476dee4215e986e7123b9d911b0a95cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "77884a43974a1b6a917d415b12d2b6fe476dee4215e986e7123b9d911b0a95cc"
    sha256 cellar: :any_skip_relocation, catalina:       "77884a43974a1b6a917d415b12d2b6fe476dee4215e986e7123b9d911b0a95cc"
  end

  depends_on :macos
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir testpath/"Test.app"
    system bin/"iconsur", "set", testpath/"Test.app", "-k", "AppleDeveloper"
    system bin/"iconsur", "cache"
    system bin/"iconsur", "unset", testpath/"Test.app"
  end
end
