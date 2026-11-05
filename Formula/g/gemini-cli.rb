class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://geminicli.com"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.67.0.tgz"
  sha256 "3f42374e88171031459ad16e5fac32b161adba330292a1822fb7aae7fb476fc2"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4e58950b2b2e112354312144efe97d229a9c949ef14fbfd85cbadbcbb0c5be4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a03104c46d5e082423147ef7e18c84a9f936aa2c18fb6233a878129d33d85b53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "09fb03d7d3bc268dfdd80398a840792ed8093f930154fd7176340785d3957550"
    sha256 cellar: :any,                 arm64_linux:       "07122a04293752fbfb7f806755dd3c7d3e02e41ce079115ad453de1fd17f4d9f"
    sha256 cellar: :any,                 x86_64_linux:      "718ac144c5e1d8b8e85c5243aac9bd7e2a1b1eb700ec87a53f9a9dd7a0805e37"
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
