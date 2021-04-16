require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-43.0.2.tgz"
  sha256 "631bbc87ada48db0c225d9f81f6c81921865d686175d8fb40f47bf1c39e95b0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "74c858a489c1d4f9dbebb3c92c105043f59e2328b72810c6d75b75cce53e56e4"
    sha256 cellar: :any_skip_relocation, big_sur:       "8617a8017656d3653fb51ed68d90f4359321ff7e332f0aa020463003540f3d5e"
    sha256 cellar: :any_skip_relocation, catalina:      "f209f65fadb14a260d0566d30b4a033d624573ba27152f96ec1464af82c45201"
    sha256 cellar: :any_skip_relocation, mojave:        "e06f4c59e370a23ac8fc97a04c4c157ce7dba0a5c0d9e0f3872ad80f98ceca59"
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
