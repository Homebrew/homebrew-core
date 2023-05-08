class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.21.tar.gz"
  sha256 "8116e7cfa30748717c578e3385a7c630958497efebfb2b74a58977a92b80adfb"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbf74e0fa1c5a622c3c69b04127fb14da4682837f3a37870cb53fb4aa2e91fb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbf74e0fa1c5a622c3c69b04127fb14da4682837f3a37870cb53fb4aa2e91fb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbf74e0fa1c5a622c3c69b04127fb14da4682837f3a37870cb53fb4aa2e91fb0"
    sha256 cellar: :any_skip_relocation, ventura:        "365130911c19a13f83bcc2417957d1bac8e8f903a30af4532d7481196b324941"
    sha256 cellar: :any_skip_relocation, monterey:       "365130911c19a13f83bcc2417957d1bac8e8f903a30af4532d7481196b324941"
    sha256 cellar: :any_skip_relocation, big_sur:        "365130911c19a13f83bcc2417957d1bac8e8f903a30af4532d7481196b324941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a41a1f29d38c2994ebdc79b87df6e84c6ecbfe973aa69a66d76d308f053873e"
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
