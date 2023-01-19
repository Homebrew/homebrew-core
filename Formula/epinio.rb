class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "8b07801efe93fc7eb8241dd05c57dd8ce1ed3568f88bfedf6340df996543cd2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be14862f70a90035a5733ef712fa1f105df9f82e7cccb87dfcbc283df0a85829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c37e3b1306d1a3758b5d65f7c04bce221a9ce993d731363feb0982a9f887fc5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c25d8858626c6417c99811a055ef75c8d8b9f7d1d2e61d540922125b27923117"
    sha256 cellar: :any_skip_relocation, ventura:        "82e4276b530a5e48ea8f78d149ba003ea4b217d43d854b6e8e730ac13497ef9e"
    sha256 cellar: :any_skip_relocation, monterey:       "bb1bab94d0e2bf182badd4c98c7d356ed4c62b0772e3beec95c619cee99992af"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab87b4bf31b53dcaf4e7ee2bfedc2e7a48d24c37f21b41b8084f231a4f6bf61b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43415f4c965fc553f85e0e1bb6a25bad0c33cc48aea386b104de01057b57701f"
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
