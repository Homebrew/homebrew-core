class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.12.tar.gz"
  sha256 "ed5079a56a6e46593dcdd89ac87badca012970af33b9765d2890baafdf10b008"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e885ac2c61ad07614e3b4c6ca934c0b926227c74c4198076221c40a701d38d3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e885ac2c61ad07614e3b4c6ca934c0b926227c74c4198076221c40a701d38d3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e885ac2c61ad07614e3b4c6ca934c0b926227c74c4198076221c40a701d38d3e"
    sha256 cellar: :any_skip_relocation, ventura:        "d51f173aecc212572fd75c7b7a6980ef8b5369747ddd7510e599f2503b6dee58"
    sha256 cellar: :any_skip_relocation, monterey:       "d51f173aecc212572fd75c7b7a6980ef8b5369747ddd7510e599f2503b6dee58"
    sha256 cellar: :any_skip_relocation, big_sur:        "d51f173aecc212572fd75c7b7a6980ef8b5369747ddd7510e599f2503b6dee58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e304616e3941c4aadbc327a7042b6870001a1e22af2d1b502994455178dd6a79"
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
