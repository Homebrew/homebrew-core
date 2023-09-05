require "language/node"

class Autocannon < Formula
  desc "Fast HTTP/1.1 benchmarking tool written in Node.js"
  homepage "https://github.com/mcollina/autocannon"
  url "https://registry.npmjs.org/autocannon/-/autocannon-7.12.0.tgz"
  sha256 "ba33a4b876b5d07e6d430481d2331170942f744a2f608c7a7c21eafe6c83f888"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa99297ea39b7efe578a7373dd57585a55a225347632e8dbb2cb4e10f452bb35"
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
