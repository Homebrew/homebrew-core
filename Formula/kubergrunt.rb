class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.7.7.tar.gz"
  sha256 "01177f523dff7c384b101c2915080f9a9636607b2202166366935a5e57989b17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e58258a3922d2de0b1a5a3c85b357159fb7f02935103328606e4e43a27199e47"
    sha256 cellar: :any_skip_relocation, big_sur:       "536503cc7635dc18a18f6c0a0d99bbab5560df004a93ef57dae3ebd74636ec22"
    sha256 cellar: :any_skip_relocation, catalina:      "a80de2082afa352721e16adcb6e063155819952d7a47596fd1af9d343b0f56f6"
    sha256 cellar: :any_skip_relocation, mojave:        "0ae90251c38408f528320e6df32d384804a85ea27b7a5ba50398a18784ccae51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6263ef2ce01c3f158af18e3a46d59b8d80f6000d7ff3183586dc3a67cda709c"
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
