class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.24.tar.gz"
  sha256 "a80beb450dffe2ab715be34590456d16b3e07b07d59f4d4c9aa9494677048421"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d60d9b7e38e0790d59d828dce2936bf4f6eb9fe69b5c0e0c5bd604444e274ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d60d9b7e38e0790d59d828dce2936bf4f6eb9fe69b5c0e0c5bd604444e274ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d60d9b7e38e0790d59d828dce2936bf4f6eb9fe69b5c0e0c5bd604444e274ea"
    sha256 cellar: :any_skip_relocation, ventura:        "823a160c77d0d460293a01c5126022facb914778722311321eb27606bd4d34ed"
    sha256 cellar: :any_skip_relocation, monterey:       "823a160c77d0d460293a01c5126022facb914778722311321eb27606bd4d34ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "823a160c77d0d460293a01c5126022facb914778722311321eb27606bd4d34ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86118399e26e612deadeee49b0bd50aa7b58c7ecbb83a51e60e0692cab2ce8dd"
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
