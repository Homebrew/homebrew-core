class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.13.tar.gz"
  sha256 "feeea4465bd0a15a0d40d4914d03bb90f30deec13039c5406c4ec848aa10da8c"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c7deede4b59438b7c5301d6dafaadc5cddd9ba35b3962b88c3cab747b5855f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "653b2bfd93d8e816641354ca18d8e810e7ad65d4362ee2b7f54c3e29173c20a2"
    sha256 cellar: :any_skip_relocation, monterey:       "d6e96ea7a81f18ad335089d41c71672ef900a5b5063abf300de2d9e94602f1b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ac49729f1f719c9558eba008a459ecc5ac3ba092559c7a8ed79bad5cd61364b"
    sha256 cellar: :any_skip_relocation, catalina:       "b5f581b61f14255f205f698c0355488558569c84216308d871ddf9f1aeaebeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cf95b4821ece155c4bd4a961a33b40fd70b141fb86f4653131dc5f8a7155e95"
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
