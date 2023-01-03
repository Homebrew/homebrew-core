class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.5.tar.gz"
  sha256 "d457d6a43fc48e307a6ae8661764f8defc0736fb28cf688e2584bb90170a4100"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f23f197cbd16dd6cdfd2823940c23226dd798de25e9ba92d0780f671ec94ae2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f23f197cbd16dd6cdfd2823940c23226dd798de25e9ba92d0780f671ec94ae2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f23f197cbd16dd6cdfd2823940c23226dd798de25e9ba92d0780f671ec94ae2"
    sha256 cellar: :any_skip_relocation, ventura:        "425d31d7a70fcd5c62deae46779429cc25f485e7d61a344cf205dbad133d97a5"
    sha256 cellar: :any_skip_relocation, monterey:       "425d31d7a70fcd5c62deae46779429cc25f485e7d61a344cf205dbad133d97a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "425d31d7a70fcd5c62deae46779429cc25f485e7d61a344cf205dbad133d97a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "792ba96acb999b4b0cdcd0470290669b74ec161a4eaaca13e3584fcfc888e5dd"
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
