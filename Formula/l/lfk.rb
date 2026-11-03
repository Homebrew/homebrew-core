class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.13.tar.gz"
  sha256 "f8d497716322a98a0609133c7f6feb94afe0185e879261f6569cf31f370d07ba"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e7c20e47da5b55df219eae15b42308ad9792f2c6faadba9b15b84dcaf13bd06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e7c20e47da5b55df219eae15b42308ad9792f2c6faadba9b15b84dcaf13bd06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e7c20e47da5b55df219eae15b42308ad9792f2c6faadba9b15b84dcaf13bd06"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e1e78b789bd8e9e670ed0b81ecca2e36eb445746631d919dd859a897a5830f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "73003e24871a9ce8e193af25e1ab0fa31d22a61411ff49e69671baf479dd221d"
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
