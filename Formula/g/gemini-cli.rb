class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://geminicli.com"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.64.0.tgz"
  sha256 "891a794e55c8319b6b78f6f8f13d6b8b2782a4709dfd2fcabf3a1f63ae8365e6"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "94945aeea6661ebfa8420180bf2c985cf9d49f61262c36eb043dc18dbec3b092"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aae96a0e8e8c8adf8157f9ccf8a3fb9c0619b873eacf03786e6dd9e2bbf735c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1b26db55dea899b2f341ae2120a13ad3c1cf5cf04d18f6f38d50b867dfc1e75"
    sha256 cellar: :any,                 arm64_linux:       "08bfd98962bedffd0684be468a9be6bf356880de0f4fb3af73faf5737fafec18"
    sha256 cellar: :any,                 x86_64_linux:      "39935574c4dc9bf6b79ca1d909d5fc81f046336b0931681219d374fcd9b2bb7e"
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
