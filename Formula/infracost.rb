class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.6.3.zip"
  sha256 "96d79e1423df4890156bd8ec0fae5aab304b2d1611614270035b8837d5dd4ed6"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "26f8664a68b039b960f0f0df6fc16e1a2a816420e71aad6ed7a9183cb8826410" => :catalina
    sha256 "7b2e16e9a7f84b674f1295d4038f60444ea8618a706cf769b1a84f2ddb2b8e64" => :mojave
    sha256 "7d7af9a8c84545c52ffa953b668a573b8eaf7a5c295cda472f02fb0ffc30bba2" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/pkg/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    output = shell_output("#{bin}/infracost --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
