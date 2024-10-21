class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.44.11.tgz"
  sha256 "744e8c543b0da3cd78c9d54c28d5d4d33a936d1fb6cf94e9db593534266e4347"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed3a9883b28f75b042705780d4c700f7dfaae3823c7dee4f3b7069ef49c1febc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    system bin/"fern", "--version"
  end
end
