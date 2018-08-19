require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.3.0.tgz"
  sha256 "e587255300cfd8e8be5afa5d9497bdb612eeeca5e165d65bd05fbd2e041ec840"

  bottle do
    cellar :any_skip_relocation
    sha256 "38aa9051550b380601f151595a0bf5cfe5b379bcc2ca698185f42c8203941839" => :high_sierra
    sha256 "11f3fcdf64f00f374af9a3dc2812fc1d99178c12146a9d8bc496496be1ab4190" => :sierra
    sha256 "44b0dc90d6d6ffaee55ebe7dd569d540f388ffaa5c15a87e1991a355d58ddc81" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    pipe_output("#{bin}/fauna add-endpoint https://endpoint1:8443", "secret\nendpoint1\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_equal "endpoint1 *\n", output
  end
end
