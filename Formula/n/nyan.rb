class Nyan < Formula
  desc "Colorizing `cat` command with syntax highlighting"
  homepage "https://github.com/toshimaru/nyan"
  url "https://github.com/toshimaru/nyan/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "308d95dc3ed978b52e4a6a058c32dd5cdcc24e1129329aa59a8261b7a23ed9c0"
  license "MIT"
  head "https://github.com/toshimaru/nyan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69ff68b4570d00000bd8b16ed1feac97ea1792a6d13795af476c8f0a2c5968e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69ff68b4570d00000bd8b16ed1feac97ea1792a6d13795af476c8f0a2c5968e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69ff68b4570d00000bd8b16ed1feac97ea1792a6d13795af476c8f0a2c5968e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "76a297e850df8a21a325896005e285a059070629716761378dc16fd2c7cad9db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4010d30c53c88986f6f0d99a6d877b14c99a800166e47fdaefbca4aef4c095f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47573a59cc0680f1d2d5bac4dcac7fc5bc2a459698e6f693d2468eb734e5bc24"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/toshimaru/nyan/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nyan --version")
    (testpath/"test.txt").write "nyan is a colourful cat."
    assert_match "nyan is a colourful cat.", shell_output("#{bin}/nyan test.txt")
  end
end
