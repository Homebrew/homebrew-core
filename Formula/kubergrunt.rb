class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.6.9.tar.gz"
  sha256 "f8f027733f22ded83a3e7beee343277cccd6e8bb2c0eeca0666d3e62ac56f4b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b0a5c7ec786c7a37af82c6e9521a9598812756d54e9a3a4028e4514a65420873"
    sha256 cellar: :any_skip_relocation, big_sur:       "5046f1e8636865644e19bcfb7e6b6f38eeedb263552e8090800a606599eea0f7"
    sha256 cellar: :any_skip_relocation, catalina:      "b1812f486a8df8dd78768c438b33e977cbb404d302f3b4d9242115e51ae8c6e3"
    sha256 cellar: :any_skip_relocation, mojave:        "294a992d8ee089a9db658d3fc4eaa78638bc4516aee65e944727a447622e509d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.VERSION=v#{version}", "./cmd"
  end

  test do
    output = shell_output("#{bin}/kubergrunt eks verify --eks-cluster-arn " \
                            "arn:aws:eks:us-east-1:123:cluster/brew-test 2>&1", 1)
    assert_match "ERROR: Error finding AWS credentials", output

    output = shell_output("#{bin}/kubergrunt tls gen --namespace test " \
                            "--secret-name test --ca-secret-name test 2>&1", 1)
    assert_match "ERROR: --tls-common-name is required", output
  end
end
