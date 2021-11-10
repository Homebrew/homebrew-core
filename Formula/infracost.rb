class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.13.tar.gz"
  sha256 "27c21b3aebc6a95af398addfb6f92706863acbbdfeda35d751aced7ded465544"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3441e092e5ef9da70e2b9cc0e5d66eb456d5dc6e33cbe141ebe70892e07031bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3441e092e5ef9da70e2b9cc0e5d66eb456d5dc6e33cbe141ebe70892e07031bf"
    sha256 cellar: :any_skip_relocation, monterey:       "23cb46ad7b96ed5ee8f1e696986d94976f808f89c444eb1dfca7454524fddb6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "23cb46ad7b96ed5ee8f1e696986d94976f808f89c444eb1dfca7454524fddb6c"
    sha256 cellar: :any_skip_relocation, catalina:       "23cb46ad7b96ed5ee8f1e696986d94976f808f89c444eb1dfca7454524fddb6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99a890bd840332214f4555c93674476dbef4cc69726e24858355ecaf9f0f0df8"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
