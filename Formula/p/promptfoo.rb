class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.106.3.tgz"
  sha256 "f9b740cec2f2e7f16b25ecf07ab9e32bd1080f3198e7eefd1151a809cbdfd128"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cd713c7e28743453b7d512035f7c79a3694d725219ace0af1f3c2e822551ddc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76bb602d6af6a442da7a991e8360f3aeb77d6c234d6f406bb5a6c2855e1b7257"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77b82a8da83a89b6f0a1dc59c544956f36647ea88cc59779c049a7c26e054969"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af163c08e0bc7c8fe2cd9de8c83bf6ff0f4236223f87cd275490c7fe630993a"
    sha256 cellar: :any_skip_relocation, ventura:       "289f45a2a1f6484956fe717f0e35fe62e2ca84c435e1f45ff881bbd42fdec18f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f811f88010233c12cea8b48404a929ce2bc9c00da7b3425c618716788724e85"
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
