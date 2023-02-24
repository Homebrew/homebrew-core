class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "46e7072cdeb01bf36a48cb6dce3d4a7cfa9bb468a996fc1926b2504235fd55ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f085ab881a684e76e7d478ec1c15fdf51bab7c8a5d821aa4c19da5564086eb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddab944aafd1dc7deb08d0bbb51f761f3689af4c1d57d657e9fb356f2c08dcfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a429969b27dbcb6a28c7930bfa68259ffde126afdacb95c3009bba88fcdaa081"
    sha256 cellar: :any_skip_relocation, ventura:        "c3182bf6eda5f8186b8e73ed276fbfd6ea86ecdb8f3204e56e1845535cb03aed"
    sha256 cellar: :any_skip_relocation, monterey:       "f6c14c7c09528fe324c62ab5d5fab6a3183ecf6c267afba8c693c4c8296c4c75"
    sha256 cellar: :any_skip_relocation, big_sur:        "f097cd2ad1de9aa019307958fa9ec1948ad2520e5760cda3053bef7214633fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b5d6e70bdeb65f9a293069e5409464e8baf45eea38242e1e4a37446d9f3b0c0"
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
