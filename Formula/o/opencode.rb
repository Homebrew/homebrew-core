class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.15.8.tgz"
  sha256 "ebc5046cc2d71b125ecb25b46785cbb54bc20fd2ca27991c1620de35cc867ae8"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "c22e9745072e81926376876d4a23ea22a3c63ddae79892545586c1df7167eed8"
    sha256                               arm64_sequoia: "c22e9745072e81926376876d4a23ea22a3c63ddae79892545586c1df7167eed8"
    sha256                               arm64_sonoma:  "c22e9745072e81926376876d4a23ea22a3c63ddae79892545586c1df7167eed8"
    sha256 cellar: :any_skip_relocation, sonoma:        "415e98b2934696fc4b9fe9f1c42867d0280ccfd153b44f05a552c2905b289096"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7f475de68173bbcc545e891a8aa4adb715276d29b349f39a5ece43ea1ae3669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "704fee3089f07a3a5307b68f5dfaedc6df93d9daf395e88dde5de872792ea2a6"
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
