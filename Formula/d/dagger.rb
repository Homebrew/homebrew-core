class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.15.2",
      revision: "b13f2c640a019a0197765e8d5cea1cc96786c487"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70d65ee6fc2a01b2abca78081bd4b4a4bad92c521545077a2ba4453823727239"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70d65ee6fc2a01b2abca78081bd4b4a4bad92c521545077a2ba4453823727239"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70d65ee6fc2a01b2abca78081bd4b4a4bad92c521545077a2ba4453823727239"
    sha256 cellar: :any_skip_relocation, sonoma:        "013ec0cc4b26bd68442a07389a02e5278818442c772f6f282515fc01ac0ea727"
    sha256 cellar: :any_skip_relocation, ventura:       "013ec0cc4b26bd68442a07389a02e5278818442c772f6f282515fc01ac0ea727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c626408e91585e3c224126f12cab4a801018f1823988578e780245edd17b29d"
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
