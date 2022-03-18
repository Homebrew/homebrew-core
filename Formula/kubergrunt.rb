class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.8.0.tar.gz"
  sha256 "cbb2faa340868a13eae0c4fe845fd45586e57afb48568c9d864725527ef26a7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "624db864f225cd62e012955622304f455c398f3fbb04bf70431a69c9c041da07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b2b9e8e800d5134736e708276e90bac44b5c52ed12ef6dd21671feaef087646"
    sha256 cellar: :any_skip_relocation, monterey:       "df59a3cf5e42717f22f59313474420100834d666fea09593d2b0328b2fa49ad3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d82a465bf245c37e56f2e70452b03fe023fd075303c714a2bcaad607d0ebaf3"
    sha256 cellar: :any_skip_relocation, catalina:       "32472be7d1c6dc5bdc8281b34529f599e316b5382b5b0518a054f61952a0e97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0febe5e67ffc420ca144fe13e08d70753b60d8a784f62c2a1d59be79064db916"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

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
