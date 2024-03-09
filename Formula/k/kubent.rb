class Kubent < Formula
  desc "Easily check your clusters for use of deprecated APIs"
  homepage "https://github.com/doitintl/kube-no-trouble"
  url "https://github.com/doitintl/kube-no-trouble.git",
      tag:      "0.7.2",
      revision: "25eb8a3757d1db39a04e94bb97a3f099fb5c9fb6"
  license "MIT"
  head "https://github.com/doitintl/kube-no-trouble.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e03c84dc5347e7931047215f1224fb92d0e3913e1c80a067cb52ba746cd8a5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c876f3965a17662b390875b14c8b464f1130da38be9b1c5a6e84ef653fb34750"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ccadcc2821aeab6bb28856b4705a66e42f41c59ad1c42b1dd1b9884d4a3bc70"
    sha256 cellar: :any_skip_relocation, sonoma:         "758d8945d7f8d95067b0c981479368761f3ad68d983f752354db018a7e09417d"
    sha256 cellar: :any_skip_relocation, ventura:        "a428e8130b5dce422a6e0bf9700b12adde7f4996074375b05d27ed07a9b6fdea"
    sha256 cellar: :any_skip_relocation, monterey:       "900174c819d9c4f1937d25d9c16a524a314a432021dc9b5a5b9b331af7dad7f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eeca187c6f80307613e5fb077c5da060747df9c407f7c6f33b17513135552b7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitSha=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubent"
  end

  test do
    assert_match "no configuration has been provided", shell_output("#{bin}/kubent 2>&1")
    assert_match version.to_s, shell_output("#{bin}/kubent --version 2>&1")
  end
end
