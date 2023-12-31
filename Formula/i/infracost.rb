class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/refs/tags/v0.10.31.tar.gz"
  sha256 "53905d6e63e05634ecc643f6166fd0ec977bcbb29409557dc290f5f7eb72c1f3"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b73e3003ea2f6ffb0d808419b950fd8da5b10a1375385e5b1ed537646d9912c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b73e3003ea2f6ffb0d808419b950fd8da5b10a1375385e5b1ed537646d9912c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b73e3003ea2f6ffb0d808419b950fd8da5b10a1375385e5b1ed537646d9912c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac56604d55e733b4f815ddf43fb44877a7d0a30214bc4d7883e5684a254d85c2"
    sha256 cellar: :any_skip_relocation, ventura:        "ac56604d55e733b4f815ddf43fb44877a7d0a30214bc4d7883e5684a254d85c2"
    sha256 cellar: :any_skip_relocation, monterey:       "ac56604d55e733b4f815ddf43fb44877a7d0a30214bc4d7883e5684a254d85c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea3ae0da92b2e87a36f5c5bcc90b7550ba2b1d591f8ad5775ac526ad82eec5ff"
  end

  depends_on "go" => :build

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
