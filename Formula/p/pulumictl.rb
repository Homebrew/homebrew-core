class Pulumictl < Formula
  desc "Swiss army knife for Pulumi development"
  homepage "https://github.com/pulumi/pulumictl"
  url "https://github.com/pulumi/pulumictl/archive/refs/tags/v0.0.50.tar.gz"
  sha256 "5950c1e147480068cf292f0e6d68bdf38a31be971ec8dad2f6052963d3fe5eb2"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumictl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48dce17fc4889c8a7b274cf58f6cd0f6a3e24063a505930f98c12fe7c409784f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07ef245cd91ed7be0b36a07f73b41e3c20a95c589a98ff50a1a41c401d90f0cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07ef245cd91ed7be0b36a07f73b41e3c20a95c589a98ff50a1a41c401d90f0cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07ef245cd91ed7be0b36a07f73b41e3c20a95c589a98ff50a1a41c401d90f0cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "054af9bbe6d7c11b30814f7aae599fdba815b7baadd3c637982f28b1c1023ef2"
    sha256 cellar: :any_skip_relocation, ventura:       "054af9bbe6d7c11b30814f7aae599fdba815b7baadd3c637982f28b1c1023ef2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2527999f798d58194819b11fe1386555234c32ed4c2be61c086a2b91aae5ca11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f708231496a7cf63fe03a18deead41fc8040f0eba7f76e8d8e9f85ebc3032aab"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/pulumi/pulumictl/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pulumictl"

    generate_completions_from_executable(bin/"pulumictl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulumictl version")

    output = shell_output("#{bin}/pulumictl convert-version --language generic --version v1.2.3")
    assert_equal "1.2.3", output.strip

    output = shell_output("#{bin}/pulumictl create homebrew-bump v1.0.0 test-repo --org test-org 2>&1", 1)
    assert_match "Error: unable to create dispatch event", output.strip
  end
end
