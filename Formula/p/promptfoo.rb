class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.8.tgz"
  sha256 "3be7edd72ce92ade5badf2d5eb8e4fbe90501db7feb147fd63f3b64b8626bc8e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e01989bbca361b0ba576c94df76f22a3874dad3466c7ffeb1ee4825ba6d55aa8"
    sha256 cellar: :any,                 arm64_sequoia: "88fde19307f793c435ef5d16e32756d7cc31415cba93927b8fd2371c7b16caaa"
    sha256 cellar: :any,                 arm64_sonoma:  "55ea639f50481506d97c6058e5fde31e79de2ceb81dd4b953931f63957fc529a"
    sha256 cellar: :any,                 sonoma:        "adce99c43712890288bca68d0c7775c6d8483209298bbc8927b7f47fc8beb749"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79e7d7e828b9f37bdd94529bc026ae913dd3c8283ac4181e8df9beb278ff012e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ca9be9545979988795589e68a98316a40c155ba3d073370caf8e94123732809"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
