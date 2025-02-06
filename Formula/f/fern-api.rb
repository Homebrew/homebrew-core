class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.31.tgz"
  sha256 "1a0db640765dde519d5b8930d458dfb74f73a765637cba61ede38f48f6382ea9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6836dd45f106113525495ffffb7f21759760891dee89a51a999dbff214dd15ee"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
