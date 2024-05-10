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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5eae4d1bd5ae29990861f991c97fa469cbfaebe0aaf4c5065b9567d7aa5e6785"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc30148c42f3c39abdacb68133d2217621577f4bdc1b15a1a9565dea2b472b29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8223a0f20b42717caf01bfe2cc14d4161a2f5f2f195c5fb4c21fc22598d8098"
    sha256 cellar: :any_skip_relocation, sonoma:         "32fafc6d629c256013e76238698ff833792d226ebab342d912ca815b119a90b0"
    sha256 cellar: :any_skip_relocation, ventura:        "25e44bf3237762b6d2b49ee438478bf37689192a17919a92ecced8497b4b5a2a"
    sha256 cellar: :any_skip_relocation, monterey:       "e349ac9cda453f141f43ba6ad8410ce595628f9d74e312156b3e8f3a3b17ae5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b5fe496b03769c506d039113fcf2d6928690911f1988953d36e6866e2450a2"
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
