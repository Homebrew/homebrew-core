class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "12b64dc97841c97287d6cc4d6653351b76816eed08f271b44c38636e6247c4bb"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9feccc173b6b15c43cf65ea7e1cadab4cb4df188f2a4a86d722a695d0553cf6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9feccc173b6b15c43cf65ea7e1cadab4cb4df188f2a4a86d722a695d0553cf6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9feccc173b6b15c43cf65ea7e1cadab4cb4df188f2a4a86d722a695d0553cf6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8f56a99d03e60ea20166f2d4557f8043ffcd04691417b9c3d3b679e2f52ece5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b18af1cbf54678c4e2c4b40f0b0e896e1597ea3eeee234f97bbe77b80d42a64c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f21f53ae0b17102020c67d234c92e560dc3717c2fd8440cb4ade86f5af1348ad"
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
