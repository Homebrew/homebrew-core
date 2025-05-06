class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "52f25b3e8b81560b321c551232d814865eb05be88f88d1075ff48bdf8394161e"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4be9df687ede5112b4cc5a1c19a8ff70133766bc29fbbd3cde5503e8e2e9c313"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4be9df687ede5112b4cc5a1c19a8ff70133766bc29fbbd3cde5503e8e2e9c313"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4be9df687ede5112b4cc5a1c19a8ff70133766bc29fbbd3cde5503e8e2e9c313"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c2cb37cf2328e9f26b8dfd1e3febe34a8acecd486d6cb718fa014bd772549d3"
    sha256 cellar: :any_skip_relocation, ventura:       "1c2cb37cf2328e9f26b8dfd1e3febe34a8acecd486d6cb718fa014bd772549d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf58f9809b5abfa563449d61f8274d65d2a29e14e728bd6c44ed7f5ed938f286"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
