class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.2.0.tgz"
  sha256 "5fdd939821ece8fa80ac89bf97ee2096ac4d452c8e84f7c31ed23fac88788982"
  license "MIT"

  livecheck do
    throttle 10
  end

  bottle do
    sha256                               arm64_tahoe:   "0660e0b12df636e85ec5f42480cec13c876ce980c49a31b0d76c0d58c4ecda50"
    sha256                               arm64_sequoia: "0660e0b12df636e85ec5f42480cec13c876ce980c49a31b0d76c0d58c4ecda50"
    sha256                               arm64_sonoma:  "0660e0b12df636e85ec5f42480cec13c876ce980c49a31b0d76c0d58c4ecda50"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c50e5be816cd115bb6f84182f8efed7c2cda7c161e888d96646f3e19769949e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a68e9011d82acca139367e54c5a608a3a7d6d2edf0312d933caf067aa36d19a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb34611c1bef81e8c722a1febde076e93a5e50e325788e521f5fd7dd28259c63"
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
