class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/refs/tags/v0.10.43.tar.gz"
  sha256 "f3e818c00f2748d488b96b86d1832d5b968b24f337e7af11e407c8abe22ab8bb"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45592f4284a4afe029e485aecaa415fbeaf0a831eb801f24f622a1a67e29a52d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45592f4284a4afe029e485aecaa415fbeaf0a831eb801f24f622a1a67e29a52d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45592f4284a4afe029e485aecaa415fbeaf0a831eb801f24f622a1a67e29a52d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1c476e5b68acc3f437d0a2304cc7ad3700762a6fc128e16637d723eaa060fd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7e1f629c6c0862f18865f910d3fa043ad5236d54ab69b8087adae83b923d25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66dead16524f33f4e7dede778dcaab0f20e5f91b5f08f5cff4c83b9c1f45e1c4"
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
