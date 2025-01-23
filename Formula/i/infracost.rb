class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/refs/tags/v0.10.40.tar.gz"
  sha256 "cba4450488ce6a8abb4ba5b88fd44c30091f95eb161c0a9ffe47f11e09fb42b7"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cf943513881346293474152aaf0cb1bc6f538131b094fe202b0574572bde5d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cf943513881346293474152aaf0cb1bc6f538131b094fe202b0574572bde5d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cf943513881346293474152aaf0cb1bc6f538131b094fe202b0574572bde5d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "72219cc68198940924a39c4580bfd7d4ce2795fcf43c4fe449651b9549a79240"
    sha256 cellar: :any_skip_relocation, ventura:       "72219cc68198940924a39c4580bfd7d4ce2795fcf43c4fe449651b9549a79240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34c991165ab472e40c6503983b2f3af603a11dcd4e108fee41c98abf3b16167c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "Error: INFRACOST_API_KEY is not set but is required", output
  end
end
