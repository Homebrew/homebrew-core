class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.4.0.tgz"
  sha256 "339916d6078d6f219ed74cc42b7a3bb70bce47754bcc5cceb9542a7c3e80695b"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "10c5228fc30a88be9126beffe1c650857cbbc1831065739981352c943085a265"
    sha256                               arm64_sequoia: "10c5228fc30a88be9126beffe1c650857cbbc1831065739981352c943085a265"
    sha256                               arm64_sonoma:  "10c5228fc30a88be9126beffe1c650857cbbc1831065739981352c943085a265"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb5a09acbd5b8dcbbdd9a23777118f0ff14c76009cf9df0bd65198e8c8aad6b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2baf60a202f4af10910b21cfdf10678029c98400a05691eac8a86a88af08d199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2be6f204bcd7e1329e9ef41231c4a921f24032ce00af204a43988b1753f1765"
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
