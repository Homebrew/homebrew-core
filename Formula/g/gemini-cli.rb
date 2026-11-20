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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b45736ce82fe9d9c50cb5aa434b5e3a123d9e267fafa95e777828b129befebc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a66aa58626aa00e282733dbdc91278bd844eef6edcd7c5927c1d4ddc65c6ab47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ddbb595cbc70410e9cdf660b97a20abbb9e588202861b1d52fc5b2809498b907"
    sha256 cellar: :any,                 arm64_linux:       "dddb6c4209d4f574b0bf9f3d52287f15195d108a3760c5221e29e3410fae0287"
    sha256 cellar: :any,                 x86_64_linux:      "cdc1d881b78dca45229c1bbc528bc97ef62978780237f6f4e021e600d86fb076"
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
