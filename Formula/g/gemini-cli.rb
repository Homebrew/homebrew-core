class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.7.0-nightly.20250918.2722473a.tgz"
  version "0.7.0-nightly.20250918.2722473a"
  sha256 "f85ddd2e34a97ac0fee0c5c916a15fc9615bd518a195f49cfa0ca2a81f7c394e"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "0ddc031a913011d38967b126c958e6b0f159fb0fff959c96b299ae895b74059c"
    sha256                               arm64_sequoia: "45fd86d0f680ba9f92a916358d304e03718cd9592a4891cade1fb8e92019a882"
    sha256                               arm64_sonoma:  "a7f2b6f67f93ec90b6a344b37063155e6f21f77240ad078123bf50d16eb7a6bb"
    sha256                               sonoma:        "7dde4d20efddc9201829be9e84917bcb5907dd49193eb20a27b9929ebfc9a087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87212a8fb266bf6851894ac061c3dbcc747784b0d8348c332635f1212691c0a3"
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
