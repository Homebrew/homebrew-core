class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.4.0",
      revision: "4a69cbf3da7d044fdfaf427f80ab8495e997cae8"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e77c5d777e103597e2196897a4c39aa39f093f560929ad89475c77d69e268d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bea80386dde82fbff42872fe2d2df1b2dfca997f3aae278d676d5fba7016456"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8829f43b0124a72e57fd31e3ef0667a2e71ad00991c1f4a17854a0c1a9e62c9c"
    sha256 cellar: :any_skip_relocation, ventura:        "30f2c91c26646425c0618561b7bd71bb56a8e89fb034958a0a2803d5e722f5ca"
    sha256 cellar: :any_skip_relocation, monterey:       "01ce47c11a86fec08c52010f742878acf2b20a64f87be44715bf7456ffedfa80"
    sha256 cellar: :any_skip_relocation, big_sur:        "95fa29ececc20eb5358d001c419cab6c4fc3e68b9c09e36be4f26b7209e1b13e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee395298f1128aaccb022dc3506fa08f19518167766fce0e6a9e5956e493ee97"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/internal/engine.Version=v#{version}
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
