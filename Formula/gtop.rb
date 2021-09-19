require "language/node"

class Gtop < Formula
  desc "System monitoring dashboard for terminal"
  homepage "https://github.com/aksakalli/gtop"
  url "https://registry.npmjs.org/gtop/-/gtop-1.1.1.tgz"
  sha256 "79552e08552d9b785d416f001e0bc84d02add1619eb9bfd9244b3e27eda399df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5adce5d3f299b11b5a5278e89c8201eb5cc4f2617b1ef88f07020a33b1df655"
    sha256 cellar: :any_skip_relocation, big_sur:       "d155b9fe2f75deabbd70c7cb6f07ac09cb69158a770b6ed8cca07d6d12cc7e60"
    sha256 cellar: :any_skip_relocation, catalina:      "d155b9fe2f75deabbd70c7cb6f07ac09cb69158a770b6ed8cca07d6d12cc7e60"
    sha256 cellar: :any_skip_relocation, mojave:        "d155b9fe2f75deabbd70c7cb6f07ac09cb69158a770b6ed8cca07d6d12cc7e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5adce5d3f299b11b5a5278e89c8201eb5cc4f2617b1ef88f07020a33b1df655"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match "Error: Width must be multiple of 2", shell_output(bin/"gtop 2>&1", 1)
  end
end
