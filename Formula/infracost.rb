class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.8.5.tar.gz"
  sha256 "2772bbef46b0cf4c1e05eec093379649d8e1f0a43de2758be7df32cb331244c8"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24aacb582952243e23da3659f8bd5ff5cd9d74514eba895ca51a6d4f3ea10056"
    sha256 cellar: :any_skip_relocation, big_sur:       "94384a9de10f36054d14e076e39979744b69665f69ee6b2ee69a63c32c240de6"
    sha256 cellar: :any_skip_relocation, catalina:      "94384a9de10f36054d14e076e39979744b69665f69ee6b2ee69a63c32c240de6"
    sha256 cellar: :any_skip_relocation, mojave:        "f8bb46d4e0c4c30c08819a07bae6be834ac4a29f4068b91e25d6bbfa96c60565"
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
