class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.14.33.tgz"
  sha256 "76c3c8d7686f61ce6894cb28f8fccdfa1a45be5c69392bfa3a5f7624ac2ff705"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "d7394445391fe7465e449f5b3ba04e7ce3ea2173c82ad1c879da9deb71d3e414"
    sha256                               arm64_sequoia: "d7394445391fe7465e449f5b3ba04e7ce3ea2173c82ad1c879da9deb71d3e414"
    sha256                               arm64_sonoma:  "d7394445391fe7465e449f5b3ba04e7ce3ea2173c82ad1c879da9deb71d3e414"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a208817f1c78665dfa224bfac8130ad3e5d7c373e1ca012fed17095063f8188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0556c006114172c2d3adaf8bfbc3400fd0a7f4d54057c618f571b4c1d4a67856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cbf43517578640f9ba9c91d945ba617a65d1b5bdcc54c211cf135b3b81b21f2"
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
