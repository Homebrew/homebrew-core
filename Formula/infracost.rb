class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.1.tar.gz"
  sha256 "b28379c767d1c2e94b3824c4ff34223621856b85bcb69ee2de9f9347bae6e51c"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "47c5b1a9e315866817d21dab999de859524cd243f4259e9e3fe871410f220f98" => :catalina
    sha256 "74465deb140a0a80237f67a83101d00da1abdf4e85c6f3511502c8afd5d2e568" => :mojave
    sha256 "602a634754477a0dff66b11eca6316139b8b8c4640b2e4adb3f87f93823b19de" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --help 2>&1")

    output = shell_output("#{bin}/infracost --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
