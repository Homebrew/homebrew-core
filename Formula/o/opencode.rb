class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.14.48.tgz"
  sha256 "de7b03286b1f2790b7ff46bc7568a94a2bdc2ea472c4af229b4a5243c499e01c"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "70ad949e7c808c4ff3e9fb8b84a89de28884e1345d42bbe7a930f622a9a8ab50"
    sha256                               arm64_sequoia: "70ad949e7c808c4ff3e9fb8b84a89de28884e1345d42bbe7a930f622a9a8ab50"
    sha256                               arm64_sonoma:  "70ad949e7c808c4ff3e9fb8b84a89de28884e1345d42bbe7a930f622a9a8ab50"
    sha256 cellar: :any_skip_relocation, sonoma:        "83a55a40b8723ce13bb72ec6f21a1e9af8e6f730d618e9c4a0be0923c0a7fed5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bfd42d4583e6f47c293dec2708f1a1fb3736ac67e1bbaeef6206b72cb265dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f79cdb29dbbd2afa490d59b936524da376816eddb02dd0c9b098d3863a4d3456"
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
