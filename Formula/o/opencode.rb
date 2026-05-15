class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.15.0.tgz"
  sha256 "9e6b777ebd407d794cbd70457e86d969e3e33cd1926fd1588e19f88f1dd40633"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "454190188cae6ce2a4c6e85d618f68de9797d337a9cd206a67382d7db9cd4279"
    sha256                               arm64_sequoia: "454190188cae6ce2a4c6e85d618f68de9797d337a9cd206a67382d7db9cd4279"
    sha256                               arm64_sonoma:  "454190188cae6ce2a4c6e85d618f68de9797d337a9cd206a67382d7db9cd4279"
    sha256 cellar: :any_skip_relocation, sonoma:        "df0dc0e3e939a649029bd4af8293193a62911a0089877ed38779e877b6e37dc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f37c6bb69bb6706e6550b9ee1f4899c49834244dbcf267d4f35ee1acc51da4bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ffd6be0b7954e54fbc862d88e269c8556b8d37a0a4bc307305b5db958ad532b"
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
