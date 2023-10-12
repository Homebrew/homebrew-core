class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.8.8",
      revision: "f549ff800a9a33562c573ddca5b8da54f3b4b692"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98060bdf449bd58a2913b2502ec063b6948b4a6fd34e1de94ba81add3eb4200f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92a82e2f07cb2fccbef4e7ba59174dea9eb43340acca93a5d0e0383f50d5a40f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcffb22b022834ba9321d912f302a16c532f99fc76a77ab8fc2e158f812cde54"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bdf0ba9b1e38e593dd7563c4044f606886db3cba7b16e87e2a0fb32583e00ba"
    sha256 cellar: :any_skip_relocation, ventura:        "f2c73786c0edd03687f9c49934318af9808ecaa3f95129905edb2d43414a7dc2"
    sha256 cellar: :any_skip_relocation, monterey:       "42fa0ce28b1d861b9a88ff019fcf7281433cde31bb09217f6488362b9cffc3e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff7ed0ebd103e76f88e41dec841a196cf47a9eb3d3684e5246b2e478161f92da"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
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
