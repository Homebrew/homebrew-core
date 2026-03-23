class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.3.0.tgz"
  sha256 "59b0332123af61dd4d12169e1e913640043c898e583ed3ee778a1322e83598c6"
  license "MIT"

  livecheck do
    throttle 10
  end

  bottle do
    sha256                               arm64_tahoe:   "2445ef8abe3605d461a45c0738b32f954f6f2728d8cec3bc5360144f4c21795d"
    sha256                               arm64_sequoia: "2445ef8abe3605d461a45c0738b32f954f6f2728d8cec3bc5360144f4c21795d"
    sha256                               arm64_sonoma:  "2445ef8abe3605d461a45c0738b32f954f6f2728d8cec3bc5360144f4c21795d"
    sha256 cellar: :any_skip_relocation, sonoma:        "10d48ce50e8a4bc2334fa7c605361659e57fba39300b3f8058930e55eb2d84f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62d06551caffe9491cf2c0d317b45d66332d6fece8d048622324b095e1bcf779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "242add13c996746f95b2fd0c46e70d230ea63d65bbff842387bdfe326cae6cd5"
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
