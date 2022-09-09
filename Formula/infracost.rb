class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.11.tar.gz"
  sha256 "25956ef500ae171d2d36c3c61017b427a8ea986c2ef17ba6f89e5f64745dfe2a"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a217fdd4ef03064b383ed7fe117e02b3769242803a147262868173c709c8c4d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "550e40bbb78747f30cb1edd5f5a00e7e72d40aea5f55d665da594d38cb735cfa"
    sha256 cellar: :any_skip_relocation, monterey:       "9a78415286fd4576d42835533b879bc96dc2a9279f670a5953281fda3d9da0ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a78415286fd4576d42835533b879bc96dc2a9279f670a5953281fda3d9da0ff"
    sha256 cellar: :any_skip_relocation, catalina:       "ad2b6af468469334745db2cb191cb35650d77e9d8b460e2bedfbd05b35a34ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec39c8cdab55cc4ec64a49f7e4cab7442f122293fbabfe168c4d2ced824119e3"
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
