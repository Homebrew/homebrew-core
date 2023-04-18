class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.5.0",
      revision: "ff7653d0dd6e2bb50243f05b57a3d5d57fad1a92"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5798178673df4ae6fa4a281043f4a2815f2ee51ad1a60dce214992f11de9a76e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "724eb0e526b73154be910a651f17c627ad546a2b28bffd59ba85b75351443b3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e67b32f69d61d76b1ff4bd25f3aa5ee8967dbd83d4444e3280dfaeb7c8f3642a"
    sha256 cellar: :any_skip_relocation, ventura:        "1b2a2be5a21ab0e662f138c650ef7c1f1efff99517d4810e221eef8ae0e93f2b"
    sha256 cellar: :any_skip_relocation, monterey:       "ca2318eb9a381e424a70036453245f5c9acda46a2a79f3ad1dffc79ae72c6a33"
    sha256 cellar: :any_skip_relocation, big_sur:        "33492d96f7a21ec5f7da2d6c004f0ebce3c55c6c05e7e659191b9b867d95c4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdafe061d36268af03ab6c109e5a75516bba19c73c4e8d07c5c532e5d93b779c"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/internal/engine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
