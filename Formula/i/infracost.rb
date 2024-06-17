class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/refs/tags/v0.10.37.tar.gz"
  sha256 "1e96a2e37548e13206acc4532e52ce0eafd9aec2f8635814706199d22778dd99"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "691a79f12678b0b7650e32069e1ca165502bc468389bad560f3aa70939b0d12e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "691a79f12678b0b7650e32069e1ca165502bc468389bad560f3aa70939b0d12e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "691a79f12678b0b7650e32069e1ca165502bc468389bad560f3aa70939b0d12e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0a834f5d15b03f74fae5f9923de5ac94b116e62845121f2b10e7be568201149"
    sha256 cellar: :any_skip_relocation, ventura:        "e0a834f5d15b03f74fae5f9923de5ac94b116e62845121f2b10e7be568201149"
    sha256 cellar: :any_skip_relocation, monterey:       "e0a834f5d15b03f74fae5f9923de5ac94b116e62845121f2b10e7be568201149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ddb9b107d43f8b054e8e43eac986b6207b9e2fd51a249fe135634ca5c58f4f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "Error: INFRACOST_API_KEY is not set but is required", output
  end
end
