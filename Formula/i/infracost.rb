class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/refs/tags/v0.10.42.tar.gz"
  sha256 "f69e980c603e61a2012c40d5b98d02debd0e032f8672110c184368bbe03b2ea6"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b2a52b5c0aef341426175e05dc95ed23da6fa4909afe93f8bebc5458f92a384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c852ef2a962736ee51bde04741f561eea75681fe9b3bc400a669e4a6c50732f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c852ef2a962736ee51bde04741f561eea75681fe9b3bc400a669e4a6c50732f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c852ef2a962736ee51bde04741f561eea75681fe9b3bc400a669e4a6c50732f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "707319b920e477c7e6f2099f0fdee9f1391ff044ce85f2d6ddc8afd05d579cb3"
    sha256 cellar: :any_skip_relocation, ventura:       "707319b920e477c7e6f2099f0fdee9f1391ff044ce85f2d6ddc8afd05d579cb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e53cd8f3909c10e55dd10dc57be12c5aa45d7793964efa2f01c3a661a20006d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f410d375827baebd72ca247aad369744b09ffe490785707806eec14902ee675"
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
