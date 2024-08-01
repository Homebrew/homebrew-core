class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.37.1.tgz"
  sha256 "97a5b4a06396d81392b0b1229d3e03feaaec25c990830a072f2c22d43de38243"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3334a9b7984b25e5e95e40af27d37abc50aac17f12dec6e410dd6e1171cb1a24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3334a9b7984b25e5e95e40af27d37abc50aac17f12dec6e410dd6e1171cb1a24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3334a9b7984b25e5e95e40af27d37abc50aac17f12dec6e410dd6e1171cb1a24"
    sha256 cellar: :any_skip_relocation, sonoma:         "3334a9b7984b25e5e95e40af27d37abc50aac17f12dec6e410dd6e1171cb1a24"
    sha256 cellar: :any_skip_relocation, ventura:        "3334a9b7984b25e5e95e40af27d37abc50aac17f12dec6e410dd6e1171cb1a24"
    sha256 cellar: :any_skip_relocation, monterey:       "3334a9b7984b25e5e95e40af27d37abc50aac17f12dec6e410dd6e1171cb1a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "327a26431ce37d6f1b9ff9ed65dff96e05239da4421d396cef11bd2f4664bb32"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end
