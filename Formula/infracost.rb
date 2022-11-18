class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.13.tar.gz"
  sha256 "feeea4465bd0a15a0d40d4914d03bb90f30deec13039c5406c4ec848aa10da8c"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98c7db475b4f9b82e9054ff7ac71bbf32ed2f8c23d15db067eb16012952688f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e40955c53108779745aa20116f692082e54d24b94b21463591c8867c6085038"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4472f21b932d270087184802015a88573b54bace13561f704b2f48f65314a2a1"
    sha256 cellar: :any_skip_relocation, ventura:        "27e6c9bc9090945caf98958c9009d6fc58fe5680143d2b9169514e69bf7febce"
    sha256 cellar: :any_skip_relocation, monterey:       "cf27d1421cb971548de0964ca08ed1e59affca2e000a9e9e33795ca5f3b3cece"
    sha256 cellar: :any_skip_relocation, big_sur:        "16acc235edb8c2f0de3b72f0f504a870cebbcab22c5a8647da35fc74eade526f"
    sha256 cellar: :any_skip_relocation, catalina:       "16acc235edb8c2f0de3b72f0f504a870cebbcab22c5a8647da35fc74eade526f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce5188095e9a1aa529eae340bd84e48b4facdf4aab4a7d78ae11c3221e4e250c"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
