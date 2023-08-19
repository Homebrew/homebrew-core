class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.8.4",
      revision: "37f9ac9aec156f39b3eab4a813cb7e9181bf35bd"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfa0df0b001f52930f36af7d28b40b5e8eaf6ef178a3112b3946b040ba46b3eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d833723b182de11a265018e3b79400b8b691971999bf961586ae98198ee48ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9b9fea9c765b69ff11475a2607400c92338a47b5a2ddfb03258a47bb03767cc"
    sha256 cellar: :any_skip_relocation, ventura:        "28c748e549bef979fc7849a05fcd39d64571eb3c6560809fca1cb2082b500762"
    sha256 cellar: :any_skip_relocation, monterey:       "c3f428d89a332c2eb6a1395086f1a2d04deae99b86a1a67ce5280889bf2547ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f4c403a7d3259374a38893f477255e5d6b9324f9d16cc1e3aa997b19fc9acc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1010b64e724dd271005e99c5b7c743efdd20383c90eba85edfce70a81d1425d3"
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
