class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.1.tar.gz"
  sha256 "790c18afc37b8715987dbf54fe57aa8e6bf65f0f7c9b87ca362523919d65f3a6"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "919097b8b218dd80def774fd5c4bfb1d1d16460c5b9cdc5f904a62c5cabbf275"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "919097b8b218dd80def774fd5c4bfb1d1d16460c5b9cdc5f904a62c5cabbf275"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "919097b8b218dd80def774fd5c4bfb1d1d16460c5b9cdc5f904a62c5cabbf275"
    sha256 cellar: :any_skip_relocation, ventura:        "4c68df37948b0b2531a061c113b35cc5997580c814eebd8217d8763a2b89a68a"
    sha256 cellar: :any_skip_relocation, monterey:       "4c68df37948b0b2531a061c113b35cc5997580c814eebd8217d8763a2b89a68a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c68df37948b0b2531a061c113b35cc5997580c814eebd8217d8763a2b89a68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13cb1fc559b309a280254ddce7b294a5dfb1fc1e3f82ce509bdcea863575a8cb"
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
