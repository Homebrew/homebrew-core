require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.18.tgz"
  sha256 "94ecaaf140c34eb2bc9e509f7fa62e2eac00d610d87006df0286806fa0876e67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0087d304cf6ba7754fb4f34487481c23ee35cba05adc5f85ed6f35a63479220c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0087d304cf6ba7754fb4f34487481c23ee35cba05adc5f85ed6f35a63479220c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0087d304cf6ba7754fb4f34487481c23ee35cba05adc5f85ed6f35a63479220c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0087d304cf6ba7754fb4f34487481c23ee35cba05adc5f85ed6f35a63479220c"
    sha256 cellar: :any_skip_relocation, ventura:        "0087d304cf6ba7754fb4f34487481c23ee35cba05adc5f85ed6f35a63479220c"
    sha256 cellar: :any_skip_relocation, monterey:       "0087d304cf6ba7754fb4f34487481c23ee35cba05adc5f85ed6f35a63479220c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccb0bf444f8fbcdfe7e4520b867f7b77b40718e36dd5759d554c842583ea91ed"
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
