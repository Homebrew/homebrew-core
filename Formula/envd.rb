class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.24.tar.gz"
  sha256 "a806aff2f9b76a40a94410d53f3d54a178cf60acebb96543e71bb289332c0720"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab28e8a78ad632cf29c3bd6d1380498dcc8341c4e231ad75eda763b1396d42c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab28e8a78ad632cf29c3bd6d1380498dcc8341c4e231ad75eda763b1396d42c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab28e8a78ad632cf29c3bd6d1380498dcc8341c4e231ad75eda763b1396d42c0"
    sha256 cellar: :any_skip_relocation, ventura:        "2f737063bf5337319b85c86858b100e74e09263edf38d0929cc8446a8c889190"
    sha256 cellar: :any_skip_relocation, monterey:       "2f737063bf5337319b85c86858b100e74e09263edf38d0929cc8446a8c889190"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f737063bf5337319b85c86858b100e74e09263edf38d0929cc8446a8c889190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b3efe1d3f96e265f13c0a6c316d613c6028fec0e4129be9d4b8b2dcaad4358d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{version}-#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "error: Cannot connect to the Docker daemon"
    else
      "error: permission denied"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end
