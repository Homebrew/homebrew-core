class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.23",
      revision: "e2653c6f9ece29b6752300b7db5eabe4ca89d203"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "110d01851f74c04537c54fd224e156763614f24b477d618c218559b11f33b1fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "110d01851f74c04537c54fd224e156763614f24b477d618c218559b11f33b1fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "110d01851f74c04537c54fd224e156763614f24b477d618c218559b11f33b1fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "94ca4fad6fe64d024d695967f6f5ce7c4b6dcf02b743cc2cd0d28ab138743eb9"
    sha256 cellar: :any_skip_relocation, ventura:        "94ca4fad6fe64d024d695967f6f5ce7c4b6dcf02b743cc2cd0d28ab138743eb9"
    sha256 cellar: :any_skip_relocation, monterey:       "94ca4fad6fe64d024d695967f6f5ce7c4b6dcf02b743cc2cd0d28ab138743eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ee6165573a2d4706c32f501afddee95eb9db8547148175de1a5f8c9dd04f74f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
