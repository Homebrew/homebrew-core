class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.6.5.tar.gz"
  sha256 "ad9f353beda616b77e6155cf33dc9a46102b3ef1b5f00bdf71d8bf935b74655f"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "74e8601905837bda04c4a99f222e3abf7ac75555526f0641dae3f31d1853135d" => :catalina
    sha256 "e2c6b8a20842b36f5aee112606b2452b63e17729edce0a79af268ab2a6754b02" => :mojave
    sha256 "2898aa18a188ee11116bff05234ec17402c0e964232dc404a8d8a0982373051f" => :high_sierra
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
