require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.12.1.tgz"
  sha256 "39c0b0ab000775377249811cbd88b5d2c0a9d4a5e921b90fce8c20511c2dcc07"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b30da664c887e17a111758e0d455a87043accf19555421043fcf447225335aa6" => :big_sur
    sha256 "916626cf79d0135debe039b8f8ba65fc399b11d45d050752eb2014eb9a649273" => :arm64_big_sur
    sha256 "d64304723f15313b836c6be3425564652e7809472f7874f46f1ae4e126a8d59e" => :catalina
    sha256 "53bc6294bfac102240ded13bf16ba4eb55a8a042e0d920a77de2393a3a916fd3" => :mojave
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
