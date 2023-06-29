class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.27.tar.gz"
  sha256 "96915c79d49bcaef0d80340fbbfdfd65f2d7e89a0f49307668eabb1af7547b9d"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22cf9c59e91deb4fe7daa53f017640c70523b67a5543ae0fb298b7b1fe167ded"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22cf9c59e91deb4fe7daa53f017640c70523b67a5543ae0fb298b7b1fe167ded"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22cf9c59e91deb4fe7daa53f017640c70523b67a5543ae0fb298b7b1fe167ded"
    sha256 cellar: :any_skip_relocation, ventura:        "17335eef056b12d0c2aaa12b87b370eede9b0f36352683afbe429cbdb7ae2499"
    sha256 cellar: :any_skip_relocation, monterey:       "17335eef056b12d0c2aaa12b87b370eede9b0f36352683afbe429cbdb7ae2499"
    sha256 cellar: :any_skip_relocation, big_sur:        "17335eef056b12d0c2aaa12b87b370eede9b0f36352683afbe429cbdb7ae2499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a3e5b52bc5047aa94536b429fec998b0b0db525642a53fb706f88b69ef15a2b"
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
