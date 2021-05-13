require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.13.tgz"
  sha256 "94ac83f1f11082843e44aa32ebb06a810d2336b3deb152eeeefa727a3dcb15f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "419e678ebd931d717b3347323fd7f3a8ac500c7b5827f568682a76466ab0bc80"
    sha256 cellar: :any_skip_relocation, big_sur:       "51ede7518157eef2556187fccdd08df80d9f8a9c7bd37a9f8eaafef5634a09d1"
    sha256 cellar: :any_skip_relocation, catalina:      "51ede7518157eef2556187fccdd08df80d9f8a9c7bd37a9f8eaafef5634a09d1"
    sha256 cellar: :any_skip_relocation, mojave:        "51ede7518157eef2556187fccdd08df80d9f8a9c7bd37a9f8eaafef5634a09d1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
