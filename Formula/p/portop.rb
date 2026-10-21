class Portop < Formula
  desc "Terminal UI showing which processes are using TCP and UDP ports"
  homepage "https://github.com/padovanl/portop"
  url "https://github.com/padovanl/portop/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e84d56316ae48ebef064d1f8e995885e93ecd2d4d3abb3ba0e8e8bfec91b939a"
  license "MIT"
  head "https://github.com/padovanl/portop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5856bc213805f2d944d5b4969b1be80a7349ad761888b7a45b3440499080bcb8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5856bc213805f2d944d5b4969b1be80a7349ad761888b7a45b3440499080bcb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5856bc213805f2d944d5b4969b1be80a7349ad761888b7a45b3440499080bcb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a4c26276a7c270778c36da324905007e64fdaaf833f495405ad38ddd9cabe0c3"
    sha256 cellar: :any,                 x86_64_linux:      "12afaa0b3f689bd8a377d0b540a551fbfa5f705772661e3795b9740fa97c03f5"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/padovanl/portop/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/portop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/portop --version")
    assert_kind_of Array, JSON.parse(shell_output("#{bin}/portop --json"))
  end
end
