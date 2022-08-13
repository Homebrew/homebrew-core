class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.10.tar.gz"
  sha256 "dd216a1f304d2b0af3de98c7df56b5eed0fac7fffcb41ca635118b94ee4385f5"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "931dc25b69422f02f455b45e433671e23d16e818443446751877b2a3bca431ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99e11d2825f283b8ad3aca13f941d2536362e637a60f06659856c8731fa69ee6"
    sha256 cellar: :any_skip_relocation, monterey:       "b882e4f5c99c50abe35db6dba1e4ecb7641ea933ab2b62746fe7784781dfc1dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b7e636d7ed39c0c6e18b0ee72bc80d1454cd456d4133a4a73b55619b7399419"
    sha256 cellar: :any_skip_relocation, catalina:       "b882e4f5c99c50abe35db6dba1e4ecb7641ea933ab2b62746fe7784781dfc1dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75aefce033c5729bf438c40ce8f9e697964e2339f025adfe14e0aecac9bff83e"
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
