class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.3.tgz"
  sha256 "a29ffed523c888368d2ade6c482656480cbe0cff83da34323cc896f31da8726d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "225b286fba1f81f3ebc0a1590eba0a182120bd358d6be7df727917f5713d12b5"
    sha256                               arm64_sequoia: "225b286fba1f81f3ebc0a1590eba0a182120bd358d6be7df727917f5713d12b5"
    sha256                               arm64_sonoma:  "225b286fba1f81f3ebc0a1590eba0a182120bd358d6be7df727917f5713d12b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "06b14a44896650afc70ae877b15d53a9b3b0c39220a873f9d7584efc3037c0ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71670b7a2dd7c2f5c235f00d25a0928c33936b4c04dcf0671c476c6f41670ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ac395a09617ad7dbd67bf0230e7edb3ef0207dafd879f29ebdad65e3f1bd240"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/@mimo-ai/cli/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "mimocode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mimo --version")
    assert_match "mimo", shell_output("#{bin}/mimo models")
  end
end
