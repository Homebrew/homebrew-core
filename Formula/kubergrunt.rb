class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.6.10.tar.gz"
  sha256 "cc4582e719783133b2f08abf5ed63b0b692a1a86678e37f30fbcb4254b580dc5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c3712e3164a8a1bdc775385f4713b113deff378d7dc70ae0eee40cc6735958d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a50bdea568a128b2590e42ab017f5418a7d299f8c130dbc0b0531b27e3e2c80b"
    sha256 cellar: :any_skip_relocation, catalina:      "7e12b504aa830a5ce348f997a013b9a51a61725508a95e0565ebeff80716d8ca"
    sha256 cellar: :any_skip_relocation, mojave:        "14a7f6007fe6cca41eacc60c384cd45b734a17c49b8596a36c537d2aff39c83e"
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
