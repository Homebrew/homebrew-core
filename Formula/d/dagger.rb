class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.19.11.tar.gz"
  sha256 "80b231338c41ade5ed71bce756cac6d2552aa52461d626e9718b11774c394e2e"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d3dca6a193563d193eee84ba28e8f382604683527b01f1bec8f3fff68fe43a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d3dca6a193563d193eee84ba28e8f382604683527b01f1bec8f3fff68fe43a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d3dca6a193563d193eee84ba28e8f382604683527b01f1bec8f3fff68fe43a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f57243c66acf5dab3fad0b1e0356a38d8dd31d741a3157416bdaaaa2d8ceb96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e4a1c004bca969a637a78fcf242a68fede8053f60409ad72d1b66723871985f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b195bdf0766aa3741f5c8d38c78ff81b3937ab6090ed9e18daff8ca478728c61"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
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
