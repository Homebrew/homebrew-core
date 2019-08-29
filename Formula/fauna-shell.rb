require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.9.6.tgz"
  sha256 "fc6ede9914fd7e96cf12b8bacf7364d215aa57b40b6b28822227cfdb32e1221a"

  bottle do
    cellar :any_skip_relocation
    sha256 "5404124e8d1fb8abd9949294e105399979d8e6c2226d43574c7188006a481248" => :mojave
    sha256 "c9333615dbad50fa2c5a0d4fdb3a279b9911517105c77c76d9da5ecd629088fb" => :high_sierra
    sha256 "633322bb48b18e75613d70dba78ffed33723528c2e4a8086d86a53f6eea2e291" => :sierra
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
