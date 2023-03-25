class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.15.tar.gz"
  sha256 "e01aa5bdc705c25c0ce5b0acd625de314e27c1fec4c63c871ba05d598a640dc0"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86787a7cfecfcd7d3b3a6e96d70a3873a2e88934b9f032d3489023c063e4672f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9edfc65d18319b5fc8bf9bd499434dcc9a1a7409a59f9738461de54b05eeccbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8077f24125178bd6a73379581239fd494cd8078919bce187b74bfbab8db20e20"
    sha256 cellar: :any_skip_relocation, ventura:        "450abc5b63149cdc9771c28e454f09288566fe6d11adf7e5da661b42b1da9efc"
    sha256 cellar: :any_skip_relocation, monterey:       "690f7b4ba42e862868da11372494d7d0beedc79e64c5db45cf83a7643c642387"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6207cb03cef7e2393db4f4d656368cfcbb5f6f86bd5103fb0eed569529dbf6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88fcb5ebed9ee7468ac80cedf463b6cabc557d47ca1a8c5ce11940de792e8e21"
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
