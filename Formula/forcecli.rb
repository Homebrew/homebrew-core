class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.99.2.tar.gz"
  sha256 "e6ce47b37f3dab9be8a29dab003492c6850d13ef605de45dacbddd9812a747d4"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85fda594e45555099b5edd007383b59db66670b4c7afe7006a7936251b8d313f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eff077dec6432fc688990fc5b0acc752af3d87da68329a49635037c2aabd49dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f616183637df2265dc216d20f7ec100a5531c63ead75d8f90f6b73ed616c362"
    sha256 cellar: :any_skip_relocation, monterey:       "48696261fb6bdab3782558f7d7dfe1f173bc47c3f2cdd57d828023192a67e628"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b95b76500298c417ce385351b37f181740416c2ce05a54968d96bd85430d5d8"
    sha256 cellar: :any_skip_relocation, catalina:       "4904051712d530ea84ed6b300f69b6dd1129d9ed718d501d55d9cd9f80886ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69d52200ee937994496e91aacfaa32584f13e55964bd306cb26dd82397c3e23e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"force")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
