class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.20.6.tar.gz"
  sha256 "855930facbe143a560650955acccda10c338fcb589f501c37d325bc2e6da04c9"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3a6a9f35551557a8138ea26806186d49fc154fa8d11e91ebd5fc1ba9bbc499d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3a6a9f35551557a8138ea26806186d49fc154fa8d11e91ebd5fc1ba9bbc499d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3a6a9f35551557a8138ea26806186d49fc154fa8d11e91ebd5fc1ba9bbc499d"
    sha256 cellar: :any_skip_relocation, sonoma:        "34f82d2a13122a62e798bbe19e312a4b1f662d8039e57f3b0bb1ba817e84e665"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d20a69b980351b780ae5ae45cd86a717b6a019b9b993bfab08ab4c6c086739f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9affd49f20f8dc1aa92f25c6853056046090287c9b9009eb15f53cca6715315"
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
