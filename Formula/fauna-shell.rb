require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.12.4.tgz"
  sha256 "227396859d27842bf8e0c1aaf54df8331aa26155250854717c7aedd00ac02be6"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a29bbe724065167b5f7b0ede868a9da8c199e220fa1c8a17f375c93d49f8a32"
    sha256 cellar: :any_skip_relocation, big_sur:       "290d23f033b99f7b2e8bb902eccf2839ac299f28851285daccdd0eb98ef5e74f"
    sha256 cellar: :any_skip_relocation, catalina:      "290d23f033b99f7b2e8bb902eccf2839ac299f28851285daccdd0eb98ef5e74f"
    sha256 cellar: :any_skip_relocation, mojave:        "290d23f033b99f7b2e8bb902eccf2839ac299f28851285daccdd0eb98ef5e74f"
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
