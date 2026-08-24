class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.13.tgz"
  sha256 "dae81e3ff4214844a76b92978ec49a4c7857c38ca351bf09d14ab77d9687f781"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b50f2e68ee6729b93ba9045e3ca7fbd85bae565258031897cd1e4810ba6f44e6"
    sha256                               arm64_sequoia: "b50f2e68ee6729b93ba9045e3ca7fbd85bae565258031897cd1e4810ba6f44e6"
    sha256                               arm64_sonoma:  "b50f2e68ee6729b93ba9045e3ca7fbd85bae565258031897cd1e4810ba6f44e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "987584b067178faea703acbc20de86ada15791e037a005db1e2fc08e51a3fe92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac9214470b33b314f1096702778cb4a5ae7bbd5b83da4f36b1efde27afac661a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a101a2743c097a776b8fc44a877dfdc80981cea7a86725ed00a1b7950dc4b697"
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
