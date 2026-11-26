class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://geminicli.com"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.71.1.tgz"
  sha256 "3381cebd8a58b43ab161fd9302d5b1f097ab2eb010278176e8afd3533d1c98bc"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    manifest_sha256 "db42e84fbc7df9fb7484d9e845d443a9c79ff4f2a3de970145512aad27d75fff"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eb822ee45fea23fd40ff9a32afe76f7bf83b6161b39ae53fa356ebeb0ed06d92"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bed31ff0656efbe55dab8e3c815c8ce8002748b2d0a47aa344f6a0842fa4cdf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b56abdde05e3291b845b9f7050c0f1c5d06721f2a3935860ed866277b160f288"
    sha256 cellar: :any,                 arm64_linux:       "d661210d86b083fce62f526e3537a6207505ba9cc808f81c008866436600302a"
    sha256 cellar: :any,                 x86_64_linux:      "aaa40502969b1a90fff1d9e76392ce2f03837171bb10fe99b25f1aa9ce6ad1c1"
  end

  deprecate! date: "2026-06-18", because: :unsupported, replacement_cask: "antigravity-cli"
  disable! date: "2026-12-18", because: :unsupported, replacement_cask: "antigravity-cli"

  depends_on "node"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    cd node_modules/"@github/keytar" do
      rm_r "prebuilds"
      system "npm", "run", "build"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
