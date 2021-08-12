require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.12.5.tgz"
  sha256 "0dc2fa7eded1c8c592ba09767e763970ed10fdbff52d8d860292da5387ce895e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c8d9554a4d4be26c580be7f080b8eccbd3c7289d0a119f120f460b80de1b0b5"
    sha256 cellar: :any_skip_relocation, big_sur:       "86ee651003e617b55b54b0e95b305a7b0b4dd69fc97f51b8b07d2b32cc9f7656"
    sha256 cellar: :any_skip_relocation, catalina:      "86ee651003e617b55b54b0e95b305a7b0b4dd69fc97f51b8b07d2b32cc9f7656"
    sha256 cellar: :any_skip_relocation, mojave:        "86ee651003e617b55b54b0e95b305a7b0b4dd69fc97f51b8b07d2b32cc9f7656"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    pipe_output("#{bin}/fauna add-endpoint https://db.fauna.com:443", "your_fauna_secret\nfauna_endpoint\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_equal "fauna_endpoint *\n", output
  end
end
