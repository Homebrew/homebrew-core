class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.5.tar.gz"
  sha256 "d457d6a43fc48e307a6ae8661764f8defc0736fb28cf688e2584bb90170a4100"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14d379c72bd23345555064a8aaf2c372f50526afa1f0cb685ac37f2cf1e0abc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14d379c72bd23345555064a8aaf2c372f50526afa1f0cb685ac37f2cf1e0abc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14d379c72bd23345555064a8aaf2c372f50526afa1f0cb685ac37f2cf1e0abc3"
    sha256 cellar: :any_skip_relocation, ventura:        "2e9b4c8c4c1d36aca4ab24908c2413577c73fee883dc1298e70f354ad663f689"
    sha256 cellar: :any_skip_relocation, monterey:       "2e9b4c8c4c1d36aca4ab24908c2413577c73fee883dc1298e70f354ad663f689"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e9b4c8c4c1d36aca4ab24908c2413577c73fee883dc1298e70f354ad663f689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e66d1c9217cdd3f1fcef02667636629f9f2a5b1b40588bafdd80a79b1b92a9b9"
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
