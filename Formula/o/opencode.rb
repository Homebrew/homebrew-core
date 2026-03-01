class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.2.15.tgz"
  sha256 "14443d5600f040dbf6f5f0faa78d51d0caf61f14b65fc7168fe593c4cbdcdbf3"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/opencode-ai/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "6d8b8770919318710b410d58ee6b4fe2f7d7560a5def43ef920c925d917798cb"
    sha256                               arm64_sequoia: "6d8b8770919318710b410d58ee6b4fe2f7d7560a5def43ef920c925d917798cb"
    sha256                               arm64_sonoma:  "6d8b8770919318710b410d58ee6b4fe2f7d7560a5def43ef920c925d917798cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b988f52790829e001da9c1b93919fc68a9ccee70b0fff91aa71e54f439f0c6ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66ba9c6afd8e97b4ea66c9876ab01e1ae253e1021c24ce281e045164ff7005f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e310180df0a0f66a63a9640613e94b9911a8e3ca3bc7df84555c82c44061ac8d"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
