class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.24.0.tgz"
  sha256 "9921ca0addc6aa687029ca8e2259f1dc1b606523b94ff838896fa69b0988804a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "408061ea60bf213567faedaeb75661444de1ae81adfcb82fbca9416d646d009c"
    sha256                               arm64_sequoia: "408061ea60bf213567faedaeb75661444de1ae81adfcb82fbca9416d646d009c"
    sha256                               arm64_sonoma:  "408061ea60bf213567faedaeb75661444de1ae81adfcb82fbca9416d646d009c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1ef2831cd7a27fde7ac3106b2b155de2d1261dceb6185109824ece54395f895"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "354a36145e2ed17bc1d10511c3c2f2f7e74e275f1f88ee19645a5379fc25e2a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6760535d57755ffa3fb4bcbdbf9d5ef9d1e7af640bc1ebc0d48a2cd7020be8cc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
