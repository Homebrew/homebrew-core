class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.16.tar.gz"
  sha256 "871987bd89a561f5ffb126bb47e02ea8beaf9b3b88602978ceb646130ac925af"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1412f6e4f826f4613a6b9e1dc14c822b1cb38f8e6be66c04afb5cf97c4a2f18c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c689df2246cd47127957f625576317640d6c3219c8cefcf66264fd7d8547232d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4198d432e2907612382b626a182fc727f0eed65c4f32a9d3c7e84230dc74bdee"
    sha256 cellar: :any_skip_relocation, ventura:        "c6a25f76bf8e5147a05a9f9e117cf1c714ad66846fb2825cfb174d8bab0bd13a"
    sha256 cellar: :any_skip_relocation, monterey:       "7408eb620f38ad68f0f81df6740467e12e2b8a3a64553cb43bd7e6bafa1dcad7"
    sha256 cellar: :any_skip_relocation, big_sur:        "845bc47bffa480adb80178cc0a28a07a33c9fab28b1d45104c7bd1266cc5ea72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4ccf83412010dd0d1374c2336b3e37e7daf0b216a63d4ffad0b525bbfc2754c"
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
