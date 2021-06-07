require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-44.0.1.tgz"
  sha256 "074b21312a05f3db86f6ee8af16dc5b6c597c4c3d6c173b0cb9b8b46417c2b12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b4e2371166a27eca64cb998bd804acd7f48e286ff4f79bed405eb10722392e30"
    sha256 cellar: :any_skip_relocation, big_sur:       "91360b25ac8a9743e6f69234df3a2fcb9fa6a53d46dbd768dd4262008e13f7ec"
    sha256 cellar: :any_skip_relocation, catalina:      "91360b25ac8a9743e6f69234df3a2fcb9fa6a53d46dbd768dd4262008e13f7ec"
    sha256 cellar: :any_skip_relocation, mojave:        "91360b25ac8a9743e6f69234df3a2fcb9fa6a53d46dbd768dd4262008e13f7ec"
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
