require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.12.0.tgz"
  sha256 "3170e5dcaaed9a0b0a96993c5d463bd196314e0578bfbff043d901b699eb446f"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "daf47c5c95fdd585174b163460de46222f00b5b33f4d2c40841bd776c3eaf320" => :catalina
    sha256 "87851f867bc3abac318d5daefa3ca5a47418bef8fbfec7d3c36c1ea7ce1f852d" => :mojave
    sha256 "c286772fc79797ad48cea7b0691d15daa2b487892734391fb5a0c7ed0ad40a5e" => :high_sierra
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
