class Cortextool < Formula
  desc "CLI tool to interact with Cortex and manage configurations"
  homepage "https://github.com/cortexproject/cortex-tools"
  url "https://github.com/cortexproject/cortex-tools/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "b67fc5092d443c0c5334df3f377ef347705ef0af2c0d048c71629e4bf87e3d78"
  license "Apache-2.0"
  head "https://github.com/cortexproject/cortex-tools.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/cortexproject/cortex-tools/pkg/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"cortextool"), "./cmd/cortextool"
  end

  test do
    # Test that the binary runs and shows help
    output = shell_output("#{bin}/cortextool --help 2>&1")
    assert_match "A command-line tool to manage cortex", output
  end
end
