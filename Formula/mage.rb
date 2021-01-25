class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.11.0",
      revision: "07afc7d24f4d6d6442305d49552f04fbda5ccb3e"
  license "Apache-2.0"
  head "https://github.com/magefile/mage.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a3707826deeb07ceb26ba6c14a532fad9cdbb865931d248675aa468c16a4c2a9" => :big_sur
    sha256 "acf15da6b6d2df49eac61aea939b1f2c59917b5ee99ad4f400dc2d9e08e006d2" => :arm64_big_sur
    sha256 "e5abfae7ded7be5c6cb847a9237ff850620cf01a5d5ec086f8777ece37f12bc9" => :catalina
    sha256 "b116c4a96c95e42a0359976929f20ebe7ebfb8dfcb4f69b911948431da1f89ec" => :mojave
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/magefile/mage/mage.timestamp=#{Date.today}
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
