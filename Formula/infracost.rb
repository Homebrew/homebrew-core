class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.3.tar.gz"
  sha256 "88d1562b0dd0c228ffe23f009959fa7fe157db46d166e6769473d8f40cca0b39"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f486f3f046511259406fa6d321bb1fb75fd07a50b0ac3d8c090ceefffb2fb24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f486f3f046511259406fa6d321bb1fb75fd07a50b0ac3d8c090ceefffb2fb24"
    sha256 cellar: :any_skip_relocation, monterey:       "a6fa3080b8c126cc6e39d467f12e33f7f4624d9315d4965409d2db5c15f0cea0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1883926e3bc1e960a95ceec28f14d3b6a18f7aee3fadd04317e543eb3ecc28f"
    sha256 cellar: :any_skip_relocation, catalina:       "bb73398ae8f3e8c0b10752fe01c31ce7acf9463e52b5dbe5cf290937f8ffaeb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb05f32d7b0dbd6b9b9db03218bcd800530818775b802cadd3708d378c1cec7d"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
