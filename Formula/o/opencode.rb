class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.15.11.tgz"
  sha256 "f0e8911f1b3c73e5b04d3ea6180be21b24c139525782779ab199c77bedd2fc5c"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "2b22fca94262d420c6bee79cf4e35e9ec057da60034ea9057d57eec206c8ccfb"
    sha256                               arm64_sequoia: "2b22fca94262d420c6bee79cf4e35e9ec057da60034ea9057d57eec206c8ccfb"
    sha256                               arm64_sonoma:  "2b22fca94262d420c6bee79cf4e35e9ec057da60034ea9057d57eec206c8ccfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d3de128338d838686e846dd084ce3567f945489a18f7483dd94c6922d61c64c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60e8d1ed086235d2f110199fe9ee9fb04a467a5a320656c4e1a90ef3e5d94a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a5afdc6f1d582dfc24749a078402c0cfc4f8720ad0330ce959034bccda1ece8"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
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
