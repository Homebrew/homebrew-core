require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-5.1.6.tgz"
  sha256 "dbdd482c494a146a14e33f11ec7b8e10d248512318b9e2da829c9471da9c3e95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb0ec1d043d2458ddb07d9f2ac495cc3f86a323c68396a83857ab2a7e05d8fe1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb0ec1d043d2458ddb07d9f2ac495cc3f86a323c68396a83857ab2a7e05d8fe1"
    sha256 cellar: :any_skip_relocation, monterey:       "861373c1c7bf3d8647402c8e4357bbbbc4f9b1142a1416943363d8d13a904657"
    sha256 cellar: :any_skip_relocation, big_sur:        "861373c1c7bf3d8647402c8e4357bbbbc4f9b1142a1416943363d8d13a904657"
    sha256 cellar: :any_skip_relocation, catalina:       "861373c1c7bf3d8647402c8e4357bbbbc4f9b1142a1416943363d8d13a904657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb0ec1d043d2458ddb07d9f2ac495cc3f86a323c68396a83857ab2a7e05d8fe1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
