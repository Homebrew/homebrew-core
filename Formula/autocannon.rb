require "language/node"

class Autocannon < Formula
  desc "Fast HTTP/1.1 benchmarking tool written in Node.js"
  homepage "https://github.com/mcollina/autocannon"
  url "https://registry.npmjs.org/autocannon/-/autocannon-7.10.0.tgz"
  sha256 "f33eefe2cf3a2eec2c3ad08fd2e64492a7762daeb0a7580bf8d6c1e8754e0d19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea8aff5c1cf90966ec5f5e80b5d6fda5cb949ec06e0b159ec071044ed6a6af15"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    output = shell_output("#{bin}/autocannon --connection 1 --duration 1 https://brew.sh 2>&1")
    assert_match "Running 1s test @ https://brew.sh", output

    assert_match version.to_s, shell_output("#{bin}/autocannon --version")
  end
end
