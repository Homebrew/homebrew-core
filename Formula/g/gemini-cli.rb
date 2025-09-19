class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.5.4.tgz"
  sha256 "4c272d3be5653bcb31ea9fbd1637c7f3f7e81da91f70b8f3e0072c1c961f57cc"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "b1340a7dd580e2576693145e11955e7a8500d6f35aae56e34ad9b2ae2aed4205"
    sha256                               arm64_sequoia: "44d893aacab0a7f41ec357af5119d1b8b49c5e593defacf1c58e8762c19b07e9"
    sha256                               arm64_sonoma:  "6cdf56c0bb54d51c0f7f2beab93e21115f55030ecb964d4f4a3a8119fdcd7168"
    sha256                               sonoma:        "3d7152f9cc7378553aed2eff47f75e46069035e57b567f88e5238bf34d40fd1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83da20006021298f43990fac780fd100adfbf4cec24c6d054c9858c9711ba3dc"
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
