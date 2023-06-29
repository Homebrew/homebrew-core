class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.6.2",
      revision: "f965b50e4217fb7a7687b03cf0cd2dc961d1a6b3"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c650f84de09eadaabc3f82f41ba8a7b2110c2b5304847a694a55f2a06a77ca18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d79bc7c05a964bd66fc37204e99167cd8b3a0146c3a461b652d298f02c43352"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bea7e799468ffdad551a96e5998e80626d820973cb23713474a7856d0822c4a"
    sha256 cellar: :any_skip_relocation, ventura:        "0f08e4b75a1b3a5660d28f69d30090c8cfeb5d724108167eaa58d6db1c2a48b3"
    sha256 cellar: :any_skip_relocation, monterey:       "32ff4c34f5efcb292ba65bf2d8d45f1e539ed233604d1179757f691b87cb37e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "01ef92f7c561bb93d44f29052b694aa63675eab5e37a6c15d7485def978326c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33add00599edf2062e65e497685ea8802f7c56a542c0451afd80d20cfa7a0903"
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
