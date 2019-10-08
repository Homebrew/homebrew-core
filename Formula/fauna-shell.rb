require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.9.6.tgz"
  sha256 "fc6ede9914fd7e96cf12b8bacf7364d215aa57b40b6b28822227cfdb32e1221a"

  bottle do
    cellar :any_skip_relocation
    sha256 "40ad964b69a275b776ddd0eba251af8d98e60d4dc80fa9f59e818f3af9c11264" => :mojave
    sha256 "638b7b36c3c691097785f991a458d09588b7e3f577d76dfaf1c59745b6c80c40" => :high_sierra
    sha256 "b001c8f4d0eb7c80830e5ee13051500b537eaa2498b6b95dfdd95a14f007c5ef" => :sierra
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
