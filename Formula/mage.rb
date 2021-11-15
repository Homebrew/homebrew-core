class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.11.0",
      revision: "07afc7d24f4d6d6442305d49552f04fbda5ccb3e"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46668f1206dea4aa54148e2ddc3d032882fe8d8b6d870e307466a897dc1bbaef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acf15da6b6d2df49eac61aea939b1f2c59917b5ee99ad4f400dc2d9e08e006d2"
    sha256 cellar: :any_skip_relocation, monterey:       "bbd18be80b12fd2649eb4d46826d0dbd191ac269d3e9f7ca1d30b35b08d06843"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3707826deeb07ceb26ba6c14a532fad9cdbb865931d248675aa468c16a4c2a9"
    sha256 cellar: :any_skip_relocation, catalina:       "e5abfae7ded7be5c6cb847a9237ff850620cf01a5d5ec086f8777ece37f12bc9"
    sha256 cellar: :any_skip_relocation, mojave:         "b116c4a96c95e42a0359976929f20ebe7ebfb8dfcb4f69b911948431da1f89ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4269eaaf9ff193b0f56e327acd9f38d2186006e918ae2ff2c267c106cd1d485e"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/magefile/mage/mage.timestamp=#{time.rfc3339}
      -X github.com/magefile/mage/mage.commitHash=#{Utils.git_short_head}
      -X github.com/magefile/mage/mage.gitTag=#{version}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}/mage -init 2>&1")
    assert_predicate testpath/"magefile.go", :exist?
  end
end
