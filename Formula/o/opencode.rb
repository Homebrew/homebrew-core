class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.190.tgz"
  sha256 "f588b9418f90d33fee018967627c954d36aa5c770ebd1dd48409241f312c1d1d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "7d148eacdc48294922fbe2013954be437d8abbac59481d776452efa89d15f778"
    sha256                               arm64_sequoia: "7d148eacdc48294922fbe2013954be437d8abbac59481d776452efa89d15f778"
    sha256                               arm64_sonoma:  "7d148eacdc48294922fbe2013954be437d8abbac59481d776452efa89d15f778"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fd777e2c86f9169a092c3f35317a33d309ce1456c587632f11d3a65be796122"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e16a0fefc41a5da4e258e35f213ef765a2d2192e31356b2f3d203c7516fcd41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b04dd6d3536ff5f33430113cc4fb5e76ab180f05e0a1928ace2527400615189"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
