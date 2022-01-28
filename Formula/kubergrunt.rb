class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.8.0.tar.gz"
  sha256 "cbb2faa340868a13eae0c4fe845fd45586e57afb48568c9d864725527ef26a7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "041c7b80659a2e5126a610ce3faaaa0fecc9c6f048c033bb77f599b9296492cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6481b4880a6ddef4f8260829ce399571db9d9891c5b392453f45f1d6c7eee5eb"
    sha256 cellar: :any_skip_relocation, monterey:       "10197d7973589c0d4d330a6186fcaee7dcbc7d1d493a456b4d332588fd6ed9de"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eecfe14ce8805e00e9661c2efd850e8b67260df30285d7f8b4ae3e04e129d0d"
    sha256 cellar: :any_skip_relocation, catalina:       "d39b4ed29352f559142816c597f19f5d6f36d6c93520e976d7993b3048b7b863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6d0f9a112b2ff4f1c06e5987c8fb9c2be0af0051d5802f6cf3732c5f323371b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}"), "./cmd"
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
