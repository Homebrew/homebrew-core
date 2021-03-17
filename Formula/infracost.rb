class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.8.2.tar.gz"
  sha256 "36445b40fbc82f8d8b35d5f8921e3e4bfd43614e347e36e6eb49b3c4ee565227"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83a986d6b90858f9cdeea48383876d4630c70119b8eb2ef98275c144c828723d"
    sha256 cellar: :any_skip_relocation, big_sur:       "d21b235009ea30df0ee51e25a63dd3e4b006b7b91c9f574b2a532a8abc7f24a7"
    sha256 cellar: :any_skip_relocation, catalina:      "1ea6ccc9b6876616e05cf7ecafc2de911c01fae1bc694b425dfd3f5bb73323b0"
    sha256 cellar: :any_skip_relocation, mojave:        "3a525b0d493b32e2d8570ae715dc33d96c8f803a8e7b897f14f0865e5e8fa1d0"
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
