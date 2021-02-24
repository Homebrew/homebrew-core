require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.12.3.tgz"
  sha256 "aa8c08fb5994b08f2eebf06c0da388dbf65a3f7e21a09d99bf8938c200302ebd"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cfbe8588059242d72ea0600146a185281aa01d605ee475f7e4cab695e3eccadd"
    sha256 cellar: :any_skip_relocation, big_sur:       "93895f6f174600ec76a2cb06c38f0def11f165e3fb23feaa0aa07c65b9ee01ae"
    sha256 cellar: :any_skip_relocation, catalina:      "9f70b2a5419ea0a3e8e16736208c337af3dd7e07c4cdb8e66da8ec05fcbf1bdd"
    sha256 cellar: :any_skip_relocation, mojave:        "3165ff49383e20add88f52d4c1e7c8c8f7a3082321f57fb0fdedb3646a057022"
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
