require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-46.0.4.tgz"
  sha256 "35b85a8b967135d8599c49721ded147c1550feb0ccef239b37f7d79b154b5262"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f4ac22f8a8b8fb4db63b3f43b58fb6f36ea5337b94d18bbef4ff75fa9c6ec9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f4ac22f8a8b8fb4db63b3f43b58fb6f36ea5337b94d18bbef4ff75fa9c6ec9b"
    sha256 cellar: :any_skip_relocation, monterey:       "e8d79a036d18cee6ab0562ef27ebc6871d13210ee14a2ab094d639f0a6e8a2c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8d79a036d18cee6ab0562ef27ebc6871d13210ee14a2ab094d639f0a6e8a2c7"
    sha256 cellar: :any_skip_relocation, catalina:       "e8d79a036d18cee6ab0562ef27ebc6871d13210ee14a2ab094d639f0a6e8a2c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f4ac22f8a8b8fb4db63b3f43b58fb6f36ea5337b94d18bbef4ff75fa9c6ec9b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
