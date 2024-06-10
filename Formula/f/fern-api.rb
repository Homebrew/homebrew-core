require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.30.1.tgz"
  sha256 "6dcd308c62454a285c8ca88a6ad8f8debe4fc5876a5848c496cc7e2f11e7cb86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa75c85015db0c669bdb95a0e6955546c0b0a3c332afd290880578c0085480fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa75c85015db0c669bdb95a0e6955546c0b0a3c332afd290880578c0085480fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa75c85015db0c669bdb95a0e6955546c0b0a3c332afd290880578c0085480fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa75c85015db0c669bdb95a0e6955546c0b0a3c332afd290880578c0085480fa"
    sha256 cellar: :any_skip_relocation, ventura:        "aa75c85015db0c669bdb95a0e6955546c0b0a3c332afd290880578c0085480fa"
    sha256 cellar: :any_skip_relocation, monterey:       "aa75c85015db0c669bdb95a0e6955546c0b0a3c332afd290880578c0085480fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d0bd9314d1814f35e6034777db4c6f5e834ccfc34781a2ed215ff3bb7f880e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end
