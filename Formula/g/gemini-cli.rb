class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.16.0.tgz"
  sha256 "e308f29581b66784bc550273e6f71640df50d88be42b02c986770abefc54be3c"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "4c5f0b243910f00569eac38dbe9a5487dfdd0be3f4ea616052fd814617649235"
    sha256                               arm64_sequoia: "57613c5db46cc5d6ff13b6736deabce68cf046310e73efa12ffa3640034987e6"
    sha256                               arm64_sonoma:  "ee0535dbf959c4972bc898ec752ed6b271e92a8c612bc1c2b86ed7ec5840313a"
    sha256                               sonoma:        "78589dee1808d104d15a214e81efa510d340d81ff2ef91510e278a638da59632"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4230222808facde4ea79307b3ea1cb150124f73f8bf006c4102f8c360505cc08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0d931017bf49d9325599a0fe9ebf319b4d85525eb05f3a506a19a708f0345d0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    libexec.glob("#{node_modules}/tree-sitter-bash/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 1)
  end
end
