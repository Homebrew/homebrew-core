class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.8.2.tgz"
  sha256 "9c86133427622e63a73ba564f27a80fcd40a3ecbc3ef919acd6b3cb0ecc7c705"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "98980d668c29a7b95e6a86bdda3b6b2303d83ee4300c18068a8058e27c9b6949"
    sha256                               arm64_sequoia: "8a7d396fd8caa4f28e0264e89099fddb245291590fc1aff399c78d5d61d3bb01"
    sha256                               arm64_sonoma:  "51a2f7128e9a7d888136344c507795c1b47ebf60704eb9b81e0bad8b98c1af59"
    sha256                               sonoma:        "08b3cf4c3d691d3c6fc75bf58829f5a75baece8b9d0b6373b44551470cf3154f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83ef2b3bb2afead2c4870e93acf4e9ea281a37a53eb1211c13c055d200ad27f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "523f61ed99e17cac73dfdb160dc46a1196bab1edd5af161e75027217f03654af"
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
