class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.2.20.tgz"
  sha256 "b48a37bef17cd601e716b762f796b91ce86cbbd5f442f646af139e3bbad7e3d8"
  license "MIT"

  livecheck do
    throttle 10
  end

  bottle do
    sha256                               arm64_tahoe:   "7eec5c24f7f48c4556b4cad59953aaad0862b01e9f33a62603b3abbc8bb8c01b"
    sha256                               arm64_sequoia: "7eec5c24f7f48c4556b4cad59953aaad0862b01e9f33a62603b3abbc8bb8c01b"
    sha256                               arm64_sonoma:  "7eec5c24f7f48c4556b4cad59953aaad0862b01e9f33a62603b3abbc8bb8c01b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bf70c80fb863be78c76761bc28d20596df0c22319cc80a76b35c31dcb72194b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54d04d292e8bf81e907e7a34ad6819030cd60465f881f27eaa52e20b33bc6a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8902bb061bb7c03f1665e0096fa16bce4be761926b3383f83ac134b3c713586a"
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
