class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "a6c232761280d37892ca31088c11c5527536ac6bbc757061d22d75dce2c88b15"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4d381bc84ed202f4d0a0d9bf8d80cec603da05f5693049c5e236fb3ae31e372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4d381bc84ed202f4d0a0d9bf8d80cec603da05f5693049c5e236fb3ae31e372"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4d381bc84ed202f4d0a0d9bf8d80cec603da05f5693049c5e236fb3ae31e372"
    sha256 cellar: :any_skip_relocation, sonoma:        "20b64fbeffe9562f4c3570ab055878ad509d924a5fbe7ab8df3b90ac4555097a"
    sha256 cellar: :any_skip_relocation, ventura:       "20b64fbeffe9562f4c3570ab055878ad509d924a5fbe7ab8df3b90ac4555097a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c4a639885277b6eb8a880a5d6944dc1407f4b073b412339ac3915f441352e53"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
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
