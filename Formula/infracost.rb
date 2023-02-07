class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.17.tar.gz"
  sha256 "034b8fa4ce467895190586953b5622bcff870d1bf868e55d13d1b1ffde37dce7"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e52d5edb5c3118274a9fd5451b5d214a7f4888c9fd6092956bbd983bd74341c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a182aa53d4f10fd7bdcd09df5e4c47355a2b4e6b529db098953ec19f793d71f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e52d5edb5c3118274a9fd5451b5d214a7f4888c9fd6092956bbd983bd74341c1"
    sha256 cellar: :any_skip_relocation, ventura:        "8a4498dce3636da2425f8e96ae651d51dbda28d2f2ed0cf55f8378a54a53827c"
    sha256 cellar: :any_skip_relocation, monterey:       "8a4498dce3636da2425f8e96ae651d51dbda28d2f2ed0cf55f8378a54a53827c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a4498dce3636da2425f8e96ae651d51dbda28d2f2ed0cf55f8378a54a53827c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e0cc4fa95f290c6143976ab0602d118b2681a0bcec124eb18df99beef108b39"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
