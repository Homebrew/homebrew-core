class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "54c194a3877074b3e9790d086abaa3d7004ace5970f856947098dcc65948fdb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a86b63d592ec6454f215e037908ac09c492d529591b8ba3e16aa4f368d036d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07726937052c0fe463096723ae92f27480cca66b1490b8e1f88bf8713056d034"
    sha256 cellar: :any_skip_relocation, monterey:       "6c4612d7f9a53e4c946f15074ffb4b7974a3d44c03c95d247ae69b6762f1d120"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e9eed194677f69dbd5ceb48c109ce92ad67d0a07542c070659461a871706c2a"
    sha256 cellar: :any_skip_relocation, catalina:       "c5671bc02813fc761366afe1d2140ed566205d16fa01cae92d8d946c85ddb34a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eff9ca6df861319afd6983ec2e02bd8494705a9df750b997ddef0317251ae243"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
