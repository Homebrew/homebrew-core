class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-3.0.2.tgz"
  sha256 "fae5699ffbbebf3d3852a17da2e03273b5f36d9bf5ac30a0efff386336056754"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "2ad4488da60715cff5769b969360d92bbe6bef653ae4c41733097e4f0b425e7d"
    sha256                               arm64_sequoia: "2ad4488da60715cff5769b969360d92bbe6bef653ae4c41733097e4f0b425e7d"
    sha256                               arm64_sonoma:  "2ad4488da60715cff5769b969360d92bbe6bef653ae4c41733097e4f0b425e7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c16d34dbb70507923e039e28a18db83f08701d2a1daeb95d74ece6ffe23c4c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26d53204bbabe0a1518bf9e76dd1a5e49d6f3733719701f6115d0a3a802a72ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6a403bcaa7590ec6b0b30ab0eb28a62995a8988e8309ad27199bda90501c95e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "Unauthorized", shell_output("#{bin}/cline task --json --plan 'Hello World!'", 1)
  end
end
