class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.11.4",
      revision: "d414522c51975886423241dd067fd896e498eed6"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "575e75d0ecd2fbe96209e8ea3edce9311079ca622e57c34116c13f466e8a0179"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef29c0910c73aa19b69b609857c34c71d0e6862a19b8b5b457dc9486b517dfad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b47d7b185322fc86b50a15c388841abf824cd66a2002231830ec13e487296c54"
    sha256 cellar: :any_skip_relocation, sonoma:         "241e4c9570e96e039deb684af3844c9823b29a19f94a0b566ab2380dfef52687"
    sha256 cellar: :any_skip_relocation, ventura:        "7827079fb50c37eaa819fbf2316b6b76d93bd7f238de32ea2ad716121e629dce"
    sha256 cellar: :any_skip_relocation, monterey:       "f6b6ed67d072768c2b9397266e1a3152949fac6b6e267161faae31a1efa07c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac4aa50056246bcc86cb5a69b47f004e4ffdeb9dc37ba6e9b3b5af5a65a8fa1c"
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
