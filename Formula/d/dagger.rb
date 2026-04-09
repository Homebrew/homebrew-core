class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "84f97e464b36535c8384ae998ee8ea0c3a0b5509bb2215dc071c2cce6bdb8ae9"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecd02d0ab0b904d0cf60307267be13d4667203dc535f90560552490161d5aaae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecd02d0ab0b904d0cf60307267be13d4667203dc535f90560552490161d5aaae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecd02d0ab0b904d0cf60307267be13d4667203dc535f90560552490161d5aaae"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad8846107a4035456d89fba0e80667a69a5e42a9a75e8b26647defcb3f07f650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89b0d291d89f3a9df39d677564b417a1ed7388b129852709b37b88e76fadc84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d002342063220f25f87801bed1a6e6f540826d770b7715b71e5c85ae8d96a89"
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
