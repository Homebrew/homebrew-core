class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.7.9.tar.gz"
  sha256 "21075b55e11a61edf30da39e5e8231e1a5cbab2801d7cdb04254047992b8bebe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90e96e0043bce6f650df116ad7f6aca744a79c73db64d5aeb8c864f4ad0bef15"
    sha256 cellar: :any_skip_relocation, big_sur:       "a4d657a8bb09b22530db13b55cc75f9b7040b6a52f0227cbbc9983dd7bae05de"
    sha256 cellar: :any_skip_relocation, catalina:      "0954826897caf566469e51a7a19707dee45b95444c4eb1a16d1c87f7c7171687"
    sha256 cellar: :any_skip_relocation, mojave:        "063edad21aa649cb363ed7adf707288219d37baeec57d6fa1966cef8f3782e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "732546cd7b8f4f11c29083416cc8c7562b6a2c2d0e0f672ee19dd94c29d3a07c"
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
