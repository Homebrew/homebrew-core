class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.16.1.tgz"
  sha256 "2f1582626b1c301f2e10489ba2d29cc47ef4053d6e3d12536d84d807b3a6d7cc"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "bda95272701d5c505eedd2da7860cdcaa20cc326a58eeab695494c886bac7e58"
    sha256                               arm64_sequoia: "bda95272701d5c505eedd2da7860cdcaa20cc326a58eeab695494c886bac7e58"
    sha256                               arm64_sonoma:  "bda95272701d5c505eedd2da7860cdcaa20cc326a58eeab695494c886bac7e58"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e41b4ba4ada4af9aadd6438a5564df90597fc002715055545f9f1ec08782e85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32657f225ec46fdefdb72e519408e224c5c88bd6af539a823ef93dc73678623e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0ea713aaa3a68a39a7320943df3d44ff1a57ee9dc005966d20be51b0048dbf8"
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
