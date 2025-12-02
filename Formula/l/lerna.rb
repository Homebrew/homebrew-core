class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-9.0.3.tgz"
  sha256 "a9e41bbe4d7f2c55bde279788216a8fb364237f605dd9af0d2bd144622c2d9de"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec9539ee9add0cff66d5be9cd96d8df351bb35925d8003a2ed7f46ec5270630b"
    sha256 cellar: :any,                 arm64_sequoia: "9909521c26cb7c893d898352db09313bb27b15e14d081209517ca04766ee3028"
    sha256 cellar: :any,                 arm64_sonoma:  "9909521c26cb7c893d898352db09313bb27b15e14d081209517ca04766ee3028"
    sha256 cellar: :any,                 sonoma:        "e646e4f75ba14ef6b5ce53cd3afa4c80ce9a506d22a2be55956274e2479ff3f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66e3d4125b76d3f3fdfb7e9497f59169c8a2f3a2363d6e1b8abaf92e1b41622f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98e8426ce48fa2630d2e61930eb202b759632e556db4ad19ef7f52d459ffdf5f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
