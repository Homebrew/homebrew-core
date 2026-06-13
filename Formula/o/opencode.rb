class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.17.6.tgz"
  sha256 "1215f803404d46dba14441ab91c140892bcebeca503a6abb4780422b8a166a5f"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "f8c5efeae87aed06518eaf9ff2c01691cc357287fcfc1f295e912cf0c59fd879"
    sha256                               arm64_sequoia: "f8c5efeae87aed06518eaf9ff2c01691cc357287fcfc1f295e912cf0c59fd879"
    sha256                               arm64_sonoma:  "f8c5efeae87aed06518eaf9ff2c01691cc357287fcfc1f295e912cf0c59fd879"
    sha256 cellar: :any_skip_relocation, sonoma:        "932b44954b587df62d44d83e6652a949c31f1dd391d409cc93c05ab386f4c022"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c1e3fe2e1565f2f3e0964c45d34eefd6ff4f243ef853a474e31b0f76c7122aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8dc6954100ad5daa74498af4e76f2d10d2018c1d1da451123975bab994d2e88"
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
