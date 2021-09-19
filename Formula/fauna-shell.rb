require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.12.6.tgz"
  sha256 "89af638e5009bd12c5d8fc9901bff8580a09a61479d15e7b3fd6fd3e3188b8e8"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "543c21f8b5b5da35305f51117a95783d4c1f4c8d5da77a60ead0e4041bcf39ee"
    sha256 cellar: :any_skip_relocation, big_sur:       "2a007b7fac07f321a6dd35a49a400a3a576dafb107b451775b5ef0b64ada5e52"
    sha256 cellar: :any_skip_relocation, catalina:      "2a007b7fac07f321a6dd35a49a400a3a576dafb107b451775b5ef0b64ada5e52"
    sha256 cellar: :any_skip_relocation, mojave:        "2a007b7fac07f321a6dd35a49a400a3a576dafb107b451775b5ef0b64ada5e52"
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
    assert_match "fauna_endpoint *\n", output
  end
end
