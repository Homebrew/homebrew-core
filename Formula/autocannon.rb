require "language/node"

class Autocannon < Formula
  desc "Fast HTTP/1.1 benchmarking tool written in Node.js"
  homepage "https://github.com/mcollina/autocannon"
  url "https://registry.npmjs.org/autocannon/-/autocannon-7.9.0.tgz"
  sha256 "7b195366e2e942f80fb3869daa29dfdf19380d3ee16740e6984acad533ab5051"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba11f16363703c8ae1d01c8961a4ec17fe1e3947b4206691442c5f95151ebcd4"
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
