class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.14.tar.gz"
  sha256 "83d61f2f4da1b57aa938eaed0f2b47bc7fef7395b6d734ac6f72b55a5b885029"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "380327d4db6dae79fbe0007f2777afa197525d10e892d5fa51d8a7542c851f1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "380327d4db6dae79fbe0007f2777afa197525d10e892d5fa51d8a7542c851f1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "380327d4db6dae79fbe0007f2777afa197525d10e892d5fa51d8a7542c851f1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcc0054bfe51bc936e0b4a80f44c65604f87d54f790894f7680c7987adea3775"
    sha256 cellar: :any,                 x86_64_linux:  "da34f854c7eda2823b557f870bd2de65a21e3b3a254bd59db21d160afac80173"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
