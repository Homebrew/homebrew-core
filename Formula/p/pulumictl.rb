class Pulumictl < Formula
  desc "Swiss army knife for Pulumi development"
  homepage "https://github.com/pulumi/pulumictl"
  url "https://github.com/pulumi/pulumictl/archive/refs/tags/v0.0.50.tar.gz"
  sha256 "5950c1e147480068cf292f0e6d68bdf38a31be971ec8dad2f6052963d3fe5eb2"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumictl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f16c5f57ad6bc4f89f15f468b9330118ab430700aba5d8277fb1c39afbd700ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f16c5f57ad6bc4f89f15f468b9330118ab430700aba5d8277fb1c39afbd700ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f16c5f57ad6bc4f89f15f468b9330118ab430700aba5d8277fb1c39afbd700ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7775fe4816a00fe38c48a7f90cfb3a96c620175dbb79b9e982384858144e848"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc8ec7a5704c20da306196d68524fb2a13956b225b43dcab8c947da99acf22ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1424eb7c55b6b704f81424e95bb63a3042fe458cc9cb9cfbd78442932bd545f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/pulumi/pulumictl/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pulumictl"

    generate_completions_from_executable(bin/"pulumictl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulumictl version")

    output = shell_output("#{bin}/pulumictl convert-version --language generic --version v1.2.3")
    assert_equal "1.2.3", output.strip

    output = shell_output("#{bin}/pulumictl create homebrew-bump v1.0.0 test-repo --org test-org 2>&1", 1)
    assert_match "Error: unable to create dispatch event", output.strip
  end
end
