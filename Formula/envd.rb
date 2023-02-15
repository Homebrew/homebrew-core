class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.12.tar.gz"
  sha256 "ed5079a56a6e46593dcdd89ac87badca012970af33b9765d2890baafdf10b008"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6bf68b7ccb0c37bfb6de0794691cdf7b2582933a5b47c54137a6eff4e647d1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6bf68b7ccb0c37bfb6de0794691cdf7b2582933a5b47c54137a6eff4e647d1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6bf68b7ccb0c37bfb6de0794691cdf7b2582933a5b47c54137a6eff4e647d1a"
    sha256 cellar: :any_skip_relocation, ventura:        "35ae464322c9dad4765c06c9b1503bcf97f6d4c17e5689ffd80f02d8529ff00e"
    sha256 cellar: :any_skip_relocation, monterey:       "35ae464322c9dad4765c06c9b1503bcf97f6d4c17e5689ffd80f02d8529ff00e"
    sha256 cellar: :any_skip_relocation, big_sur:        "35ae464322c9dad4765c06c9b1503bcf97f6d4c17e5689ffd80f02d8529ff00e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9ef37a9bc4cca18bd4333b0992f7f48432a115b58a6ca0403998ce6cac35499"
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
