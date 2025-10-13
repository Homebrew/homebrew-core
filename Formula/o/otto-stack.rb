class OttoStack < Formula
  desc "Powerful development stack management tool for streamlined local development"
  homepage "https://github.com/otto-nation/otto-stack"
  url "https://github.com/otto-nation/otto-stack/archive/refs/tags/otto-stack-v1.0.1.tar.gz"
  sha256 "c5852353b0e7cc6ba037f85b3d6ad779552623f283b3e986992b1ba72a52bc5d"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/otto-nation/otto-stack/internal/pkg/cli/handlers/version.Version=#{version}
      -X github.com/otto-nation/otto-stack/internal/pkg/cli/handlers/version.BuildDate=#{time.iso8601}
      -X github.com/otto-nation/otto-stack/internal/pkg/cli/handlers/version.GitCommit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/otto-stack"

    generate_completions_from_executable(bin/"otto-stack", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/otto-stack version")
    
    # Test init command in a temporary directory
    system bin/"otto-stack", "init", "--help"
  end
end
