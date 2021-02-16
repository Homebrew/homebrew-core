class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.19.tar.gz"
  sha256 "dc9c1fc665685068bd917df32605d9cadee4fd3ef863cb882ec4fa845d2995ae"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0dc6aa182d44734d9e5f2bfcb4f0cbda875675152fc61b960e8207f840606b50"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd85941690a17bfa0f148e537ea318d45b14da39dea5c0c126bff63f03a5591c"
    sha256 cellar: :any_skip_relocation, catalina:      "2eb6a627b0b44867208264d1b116f54bc93c008d69422d209d0a53d9d51b7244"
    sha256 cellar: :any_skip_relocation, mojave:        "6126445ef5d950a418f3201941aadd93d151a7d4dae1a1c752b723ee5235c280"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --help 2>&1")

    output = shell_output("#{bin}/infracost --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
