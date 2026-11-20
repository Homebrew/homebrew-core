class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://geminicli.com"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.69.0.tgz"
  sha256 "be20f6f8103f19df4a9cb8ad8b0744cd2a3335bd9fd3c6664f3235306e18172c"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "254090b4143ab509c0245ed3275e16e218aa63224048303e96881018497e2500"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb60b66d272b0c1b47c4fdd632d2d668ecc2506f73f607295b7d9690325f7f0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78a49363d864ae853c63dcf47a78c5867fac60b1becc66f422f9b41737aeb4f7"
    sha256 cellar: :any,                 arm64_linux:       "d3c2e8324bbe65f208d8aaf725401ed1d08d5f44caf506e2f3e7298484b47fe7"
    sha256 cellar: :any,                 x86_64_linux:      "5428e3f94c6f7923077d5267a03aaf9d38f463195ac21af77be725673301aca0"
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
