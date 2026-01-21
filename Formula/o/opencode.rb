class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.1.20.tgz"
  sha256 "5b66722ab09c46ab18613bceb1cd0c3953c0bdab146f43db9f6ae43e11c2a227"
  license "MIT"

  livecheck do
    throttle 10
  end

  bottle do
    sha256                               arm64_tahoe:   "4bdd8fbd54505599288d2bc73c8ff944412fa445bce7a8a40ab2bcd2cf3afe7c"
    sha256                               arm64_sequoia: "4bdd8fbd54505599288d2bc73c8ff944412fa445bce7a8a40ab2bcd2cf3afe7c"
    sha256                               arm64_sonoma:  "4bdd8fbd54505599288d2bc73c8ff944412fa445bce7a8a40ab2bcd2cf3afe7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a40994ae9c1b31a934865cd3784bfe22f9798435bf2a88d454a96bfb1820eb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "659c0c740f32506ea76fd07c460cbda796d23a4a5ed24687477425dd7d7e6fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c06dc73c81426b15429ef3a7ce6fe44c09003116de088023fa7fee0bcfc03372"
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
