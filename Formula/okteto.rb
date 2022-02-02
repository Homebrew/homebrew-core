class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.15.3.tar.gz"
  sha256 "e7165498e79749d07744f0f7c2774b2f165a5f2a0332aa192a44b1deaaefff47"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6c7318453369ac13aa75433ee86373492b5457c8ad9f50018725b65d02e4be3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc206f463c9e1570bf7d79f1192639af1be1ab19ffdc58bd70e25513145ab5dd"
    sha256 cellar: :any_skip_relocation, monterey:       "4d44f29f510bc7ece845cf246631956e7fe28080c807acf766293e96246eeb8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "80bb5c57a8098707f1268ec2113b9ea504ca56e8a239d10448aedfe6f81fe353"
    sha256 cellar: :any_skip_relocation, catalina:       "3b04004a39ec701f9a3998e02f0746ea792cd87a3ec2ccd6b13007c80a549922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "533489067da8a793cff910a30e906db248fe13c50422eccc043eefaef766b843"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
