class Gnhf < Formula
  desc "Autonomous agent orchestrator for long-running coding tasks"
  homepage "https://github.com/kunchenguid/gnhf"
  url "https://registry.npmjs.org/gnhf/-/gnhf-0.1.44.tgz"
  sha256 "c8d4de0fe690c8ec33168e9cee0675c9e4bf4aef0fe0e027a4e2e459687b4000"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8eb1e36c11001a028e9c4a3053ac1549f1fa43144016a2429635e1b10274690b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnhf --version")

    output = shell_output("#{bin}/gnhf --current-branch 2>&1", 1)
    assert_match "gnhf: This command must be run inside a Git repository", output
  end
end
