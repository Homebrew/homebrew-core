require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.10.0.tgz"
  sha256 "0af05027f5d01d9058db45d24955ba2ab41591237f9b9af62b7c8e34fb7ef055"

  bottle do
    cellar :any_skip_relocation
    sha256 "58df3d2064ccb0dc335e05365850d72d84546907f53d933e22ec48843686a50f" => :catalina
    sha256 "f02dfad16bb4edffd02de46ccd6a4fc40d4a7d1d79c622d547fb08e5b6612c68" => :mojave
    sha256 "20709502538d7f8f753a464b78398b1f1e78223ca65417e092d2678c5c04ece1" => :high_sierra
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
