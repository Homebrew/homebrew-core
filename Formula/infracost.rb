class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.6.2.tar.gz"
  sha256 "d792710c9dda27f5aa643e1ad8ee20694077d9564cea3e0ce058c7b4b193ccb4"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "446aed353b4f1aa83c5a40eed1eff64b1ff56f4af36e18b37c41c4f34d379d49" => :catalina
    sha256 "563c1d401e52437f789c5924f8c974edfd3be17ca72bda56e1e97b9357c5c37d" => :mojave
    sha256 "716e3ef77e733db8e4621997ac1c3131f4e4ee7df5c238016e07f88af641dee7" => :high_sierra
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
