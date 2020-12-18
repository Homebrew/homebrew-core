class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.10.tar.gz"
  sha256 "4b710923810d924ebca059ed941f69e9404d0dcd5114a8e4b2fc3cff04e725f2"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3db8d1abb9a771ffa972132ad6ec8fb4b2188f86f618eb42a5de3dcba1170ba5" => :big_sur
    sha256 "39dce00ebac276343caef72d87487d6acf7a55af49d58baf346a84bda8b17a71" => :catalina
    sha256 "3a09881b96521e109f6dc6cc60c36fdf2bd0cb588bf424638440fb8a791afe14" => :mojave
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
