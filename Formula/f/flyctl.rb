class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.107",
      revision: "2bcae051d207f47e64b57383c099521751b302e7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da027b02d2761e07e64d77a30391bd0a1957609442753f89bb6c16909674ee9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da027b02d2761e07e64d77a30391bd0a1957609442753f89bb6c16909674ee9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da027b02d2761e07e64d77a30391bd0a1957609442753f89bb6c16909674ee9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1d818261c82cc63db13d0d50892909fb11247118c81f1993c272edd4eae94c0"
    sha256 cellar: :any_skip_relocation, ventura:       "d1d818261c82cc63db13d0d50892909fb11247118c81f1993c272edd4eae94c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afb3a7bb20a9edbb51b3cafe57ecafe2fd9b111e6dbcbf28fa087209d98b1286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbeea8cba18f1359e288c32376f3ace6be5ba37f1f650520c43fb088d4569267"
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
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
