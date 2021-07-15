class Ksync < Formula
  desc "Sync files between your local system and a kubernetes cluster"
  homepage "https://ksync.github.io/ksync/"
  url "https://github.com/ksync/ksync.git",
      tag:      "0.4.7-hotfix",
      revision: "14ec9e24670b90ee45d4571984e58d3bff02c50e"
  license "Apache-2.0"
  head "https://github.com/ksync/ksync.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "75b929e1d0d310d0a0b875936e84f62f407be3b275659ce37875d4131b02206b"
    sha256 cellar: :any_skip_relocation, big_sur:       "abdae6cfb9a6e71f0580c21d576cdba97462c95eeb0d98bf380562991db3e06b"
    sha256 cellar: :any_skip_relocation, catalina:      "8424ffd61d19d4cb33bb433482b09e9d9980a0ab0a5ac1721091be8e377dcec6"
    sha256 cellar: :any_skip_relocation, mojave:        "e3548758ab06f87ad12fdb1bc25faa555c0f46f476754e0cc92a306f977cd094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9c17bb8e01e9d2d6b36091c70aec324c299f4186241233d6cb6f460e375de34"
  end

  depends_on "go" => :build

  def install
    project = "github.com/ksync/ksync"
    ldflags = %W[
      -w
      -X #{project}/pkg/ksync.GitCommit=#{Utils.git_short_head}
      -X #{project}/pkg/ksync.GitTag=#{version}
      -X #{project}/pkg/ksync.BuildDate=#{time.rfc3339(9)}
      -X #{project}/pkg/ksync.VersionString=#{tap.user}
      -X #{project}/pkg/ksync.GoVersion=go#{Formula["go"].version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "#{project}/cmd/ksync"
  end

  test do
    # Basic build test. Potential for more sophisticated tests in the future
    # Initialize the local client and see if it completes successfully
    expected = "level=fatal"
    assert_match expected.to_s, shell_output("#{bin}/ksync init --local --log-level debug", 1)
  end
end
