class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.5.1.tgz"
  sha256 "fa2ecfe35d9efbb370902fa3f630c98dd242e5f378871b7db2e302f745767345"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "e53f6fd4498c8bb19817e531f1f899be1de49d76855761f95143640bed528d4f"
    sha256                               arm64_sequoia: "20e4728f95b54e09bfd7c0b2b2508032726d50a4266f51780e5ed08432327111"
    sha256                               arm64_sonoma:  "eb5687df8e4c0ea08a28fb46f3eccb2fedf90c4efb4d01f960b7259923b153e0"
    sha256                               arm64_ventura: "15b9245524eb26637f1ad9fa00796ba5249df1efdff963533be2fa015ea1d9e5"
    sha256                               sonoma:        "c1743b99050a44d36e09d48901828dcd0d0c3773590387af727123601f352385"
    sha256                               ventura:       "4938efe972a5598e74cb24d4e429caecec2ea85e37cc3fcbd7aff5cb0b51f254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93e0cc56e35b44f59bb7dcffaa36dde13bd740996e1cce1dd7ca7fef98aca2a7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end
