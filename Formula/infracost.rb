class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.16.tar.gz"
  sha256 "c7ddd1b21d6a4a3ac613c8e530128624dc30fe5945efcf773054976a3316d1a4"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0706f2f7f7f2bc7b6eb5117f13cf5916f8fa8e1d3f418a6fc41002e49eb51f49"
    sha256 cellar: :any_skip_relocation, big_sur:       "da71692bd66f67588b06a8d4107c71880cc209c8f352a27412584e1044c4b66c"
    sha256 cellar: :any_skip_relocation, catalina:      "5f14658b02ef40635403c0b7bbf8c54e6448a0e7a3ba8a4cb5ba64610bf4bd6e"
    sha256 cellar: :any_skip_relocation, mojave:        "f099456365574cc31e7e768259bd60c520a34b4a7466208f9222774f081f9c09"
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
