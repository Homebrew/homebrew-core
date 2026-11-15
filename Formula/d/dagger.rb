class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.21.11.tar.gz"
  sha256 "90cdd1012c73317ed41da4feae5abf3f08634c2816f30f0e54a2d7cb9e20df63"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b36cb4d7d9bc9efc9b8d9e6763a04210f636585ce3a63f599abce5d1c772af7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b36cb4d7d9bc9efc9b8d9e6763a04210f636585ce3a63f599abce5d1c772af7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4b36cb4d7d9bc9efc9b8d9e6763a04210f636585ce3a63f599abce5d1c772af7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "87a6a81395bbb42d8a87a02ebe58b4b753f832533546399f6e348f2bb018ff76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7f36706db3f9da578173b88829db5e385baebad78700445f9a5423299e41cca3"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "failed to connect to the docker API", output
  end
end
