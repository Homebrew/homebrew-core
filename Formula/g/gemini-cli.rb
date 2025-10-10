class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.8.2.tgz"
  sha256 "9c86133427622e63a73ba564f27a80fcd40a3ecbc3ef919acd6b3cb0ecc7c705"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "f79cbaf7e24fc728c4aca5860bf4ce6152dad6fe8e15fb9e3bda36c33756bf50"
    sha256                               arm64_sequoia: "7c529d22c239a22755a5be84dea695e51a0b66110447a59ceef24ec74b439c0f"
    sha256                               arm64_sonoma:  "f12f60de242d7d6e96f6c77103fa7d216541200bebfbf8d60d690a4582c61a67"
    sha256                               sonoma:        "d483696dfee182e0a0f834c136d12b88d868539182559efa2d8805f9bf54c5b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "432e1e5c6fbf7128702f54c1d533be900ff1d9bdb79e3fe0c6dee4790fb2a22c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6daca33a5b32e8eae6eb121dd1126cbf1273dcdd2c8c79b791315a9b7552d9d0"
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
