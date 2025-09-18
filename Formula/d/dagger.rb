class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.18.19.tar.gz"
  sha256 "f17bc348986d6a7720b17ca36acfad27a8f39decc0b86af59b0933ad8949e2ff"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d19bfc5233116043dee17ce84e638c62ebc4558de812726249de54f78e8575f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d19bfc5233116043dee17ce84e638c62ebc4558de812726249de54f78e8575f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d19bfc5233116043dee17ce84e638c62ebc4558de812726249de54f78e8575f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a42c37a0e53afbb7c70b6f1c719dd89bf06d63319a14f20938dede311811101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65840ff3e9cd87c08c56fc20253653fc5841af19734c2b89e21223e0db9d69db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8435b4a4300ec15a35e89b5d675aaef790cdf586441ea5b4271f623bcd86ca7b"
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

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
