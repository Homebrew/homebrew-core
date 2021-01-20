class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.14.tar.gz"
  sha256 "c7a2f0d2ee9ab39a266a2f744b21e61bb6520c7a8f3deaf53c6c08e66c4aa695"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ef7962b02c540fd39cd6d9a703410e1884a06341294e797cc1015539ca26f80" => :big_sur
    sha256 "feefbc643626faa12de2177731febd010ff7bc7684c3f9f59798b5e19b857f6b" => :arm64_big_sur
    sha256 "d7b91de058dce9e91ef89aab89b9eaff229b21296655bbaaabb1b0832808410b" => :catalina
    sha256 "ff2d87ad5450309eb2f8333058a56984afb56382866eeeb4e1bb11b963f20d5a" => :mojave
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
