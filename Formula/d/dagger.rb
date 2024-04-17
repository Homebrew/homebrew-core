class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.11.1",
      revision: "53eb40c8f50e941dda915e14ee37d06cd4f48ef2"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "993725670e7e1be6babbfa064b5c94df66efa94fb4cebb6ef1e140d54ec77c93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1aa05e3b9fe30f2d462648d842de5a7c61b734d6495e7745b8993ec13255979f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4ac2854a8713df4fc6c741e3895ffd2922d5a8ea811eee8f5623343e2409638"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ca35973e46ba27c06ab17546637f09367ae6eb31380c095f6aae645312221b8"
    sha256 cellar: :any_skip_relocation, ventura:        "0e8701d1baaf7f80a5726605f27554570ef85c2e9b90f4d0b99b1164c87c570f"
    sha256 cellar: :any_skip_relocation, monterey:       "b47a1d59ca0f8ad6e445f2701c21514fd166ca331389cce067876b315b793a69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d8acfb4b39597a9c5dc04cec52e94043bedf7c42f4866f334f74549141583b5"
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
