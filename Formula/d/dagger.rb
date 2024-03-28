class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.10.3",
      revision: "571f02a63c9aee8a1c10b818ec2f2e0794802b99"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25a2b37d7bd040e9892ff37becd155cd89fbbd4096338d9b90553cef99d83591"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88d3bf824bb11909ec9ee0cf4ea04cd7d7a57629b1b70b9717b286ac04bd9823"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8985120d85f1059a562911fbd2a0a6f1a1c061da64b204c3e6dcaad96b3dacc"
    sha256 cellar: :any_skip_relocation, sonoma:         "1173355a26479049eaff25c7a84116391299b362f30fdcf987bd265ee2a2490f"
    sha256 cellar: :any_skip_relocation, ventura:        "342fe19d010e4b88708e4551d9bf1a49f17b31008065796bfa9a23fe4eb70ed1"
    sha256 cellar: :any_skip_relocation, monterey:       "6371bd1e192bf624ef11b326e0b8fac768614a81d99d992ec1b07e4e5a67265a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e5df132ef2d3a3ebed19012318fa5a3a12acf83acac0ea9a7b3baf6095861b5"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
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
