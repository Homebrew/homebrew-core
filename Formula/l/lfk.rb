class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.15.tar.gz"
  sha256 "93eaede773da47f702e5f48fe766bd12d8bd01191617bfe6732c9d4e9593816e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33f4a784196c91163c380cf805209b5bbeb82307e2e7b5dc1414bffc240a70e1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33f4a784196c91163c380cf805209b5bbeb82307e2e7b5dc1414bffc240a70e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33f4a784196c91163c380cf805209b5bbeb82307e2e7b5dc1414bffc240a70e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "915b37bc2cd022ded22db206584c92b1913107848ae9b2cc46e938bdce4a60f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5826b80473e6c103be2de920d67643e5aac17c54077bb25997e836c1479da4cc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end
