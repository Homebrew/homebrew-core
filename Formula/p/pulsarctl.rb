class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.8.tar.gz"
  sha256 "69a619ae4150e5f6f06b556665eb845cd0d3037677015ddd4155ac4de3d9055d"
  license "Apache-2.0"
  head "https://github.com/streamnative/pulsarctl.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to check releases instead of Git tags. Upstream also publishes
  # releases for multiple major/minor versions and the "latest" release
  # may not be the highest stable version, so we have to use the
  # `GithubReleases` strategy while this is the case.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "076e6a7ca409116f67048f8e8622a5f9002e206a5162f6be75281810688923aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "076e6a7ca409116f67048f8e8622a5f9002e206a5162f6be75281810688923aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "076e6a7ca409116f67048f8e8622a5f9002e206a5162f6be75281810688923aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "5804297d3a823ab4ea5d790a1d24740e9a07c1fd9e2231a0b0843d8bf1edecbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de450fcc15598aaec939e844117668112ee8081f8bf5f37f1c92b13d7c21652b"
    sha256 cellar: :any,                 x86_64_linux:  "c416973e7741a66c508f7ef6f9276eee7f13248ecb88226d87b6768913014b30"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.ReleaseVersion=v#{version}
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.BuildTS=#{time.iso8601}
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.GitHash=#{tap.user}
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.GitBranch=master
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.GoVersion=go#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pulsarctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulsarctl --version")
    assert_match "connection refused", shell_output("#{bin}/pulsarctl clusters list 2>&1", 1)
  end
end
