class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.26.tar.gz"
  sha256 "0c98f33cce49dee7ea578a682d73e0f23ee6d8d57bd2a759b413ad51f83beb24"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4490ea153940cf49ee4cce32384e70344c5fca69a5f62e2dd2b218b61a6ab6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4490ea153940cf49ee4cce32384e70344c5fca69a5f62e2dd2b218b61a6ab6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4490ea153940cf49ee4cce32384e70344c5fca69a5f62e2dd2b218b61a6ab6c"
    sha256 cellar: :any_skip_relocation, ventura:        "06e2cb01208a766f5a49e7c22d270b8bc01b695bfa2a298c63bc3271ac9dcb13"
    sha256 cellar: :any_skip_relocation, monterey:       "06e2cb01208a766f5a49e7c22d270b8bc01b695bfa2a298c63bc3271ac9dcb13"
    sha256 cellar: :any_skip_relocation, big_sur:        "06e2cb01208a766f5a49e7c22d270b8bc01b695bfa2a298c63bc3271ac9dcb13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de98086a0839f2faae9dda1ea0d6f7a91ff44794ac429b5b495baa12ac2dbcc0"
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
