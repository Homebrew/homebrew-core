class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.20.8.tar.gz"
  sha256 "e1aedd95c92b5ae5179d9d3aa621157fdc11e2cc4b2a10c3cf7d9200d6d65617"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abb37f3aab35cc6e3f3b32dcf0e73b09b053f79f49706f0d7979e2b217ca0d9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abb37f3aab35cc6e3f3b32dcf0e73b09b053f79f49706f0d7979e2b217ca0d9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abb37f3aab35cc6e3f3b32dcf0e73b09b053f79f49706f0d7979e2b217ca0d9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b4d33a9bab0505347964846add9f995e252b9bc8169076874d0fba7027b4a5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c640522177442f07ff2e996f11e3d395a528fbe02b56e5d4d98f38efa508f5f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da962035b367ce4b45b1d22ef9b7cbfdf6c6029f1e25fe6a01172dc320f6a3f"
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
