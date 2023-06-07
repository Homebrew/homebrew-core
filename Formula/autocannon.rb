require "language/node"

class Autocannon < Formula
  desc "Fast HTTP/1.1 benchmarking tool written in Node.js"
  homepage "https://github.com/mcollina/autocannon"
  url "https://registry.npmjs.org/autocannon/-/autocannon-7.11.0.tgz"
  sha256 "0b7b7df9126343782e860eeb84b663d6634f54a1e40f7e472b9350eebb72512a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e453bf6b7d26b06fd7d28a39a75e55dbd91a3a0eeded160fa6899a916d6382ae"
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
