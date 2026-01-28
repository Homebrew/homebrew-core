class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.1.40.tgz"
  sha256 "a1ab40de6e1e39aae9f7b632a683f63d7a3d004f5281d03c3a246c967244721f"
  license "MIT"

  livecheck do
    throttle 10
  end

  bottle do
    sha256                               arm64_tahoe:   "f76e02de5271bce6ec25ce01be18a74faf3b69d3771c35b534c4398485eeb0d8"
    sha256                               arm64_sequoia: "f76e02de5271bce6ec25ce01be18a74faf3b69d3771c35b534c4398485eeb0d8"
    sha256                               arm64_sonoma:  "f76e02de5271bce6ec25ce01be18a74faf3b69d3771c35b534c4398485eeb0d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c73c57d10499ca88b142cf2fb25af291c18e59fc3c5ede90bbff558f6971f51d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde5e8a73bc0cbba2f2f3b56e70ba59ce708a0e88b81ca6b6193084972d66bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c94deac1237bcb0d82c15bf5a910874c3b07e562a13cb0cab87c4d2a3e48e05"
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
