class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.10.2",
      revision: "f123072dfde8fd15f9c9ecf5bc2c11c5228ac5e7"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7294ab20d43deae1b427b2c61f130d4c17fdf4589836e2c0318bf79da6b8c48d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f42d9591b3ebd60ab44c1ca1885af2bdaf127ae61f622b89cefba30c195635f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e08badcfd723cada75e42fa96c3627f18e50a7e5972cc51d702f40ad2461d4bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3003d66d905f39d7e454177a4464623d2cc5b791626663a0f6c74465ac95def"
    sha256 cellar: :any_skip_relocation, ventura:        "bda86a026ef5dd29943a90bc045401236e8ed9fd88e86b8bc71dd80ebb816247"
    sha256 cellar: :any_skip_relocation, monterey:       "42ed8a4481cd2f60cf8760471af8e196d33138c4dde6a7557d32f2c6eb79b506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e209e8901c941822bf66fc378a5441c6ee6f7b8e7eaea38e569970cee2b09fd"
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
