class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "3638179bf055575e3f9c947a848c8e973a692c172b40e1a06ca55d2089a9384b"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "404929f74bb1634f83da611f81c10329574ad580670c9af54e13a7a1292e69ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "404929f74bb1634f83da611f81c10329574ad580670c9af54e13a7a1292e69ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "404929f74bb1634f83da611f81c10329574ad580670c9af54e13a7a1292e69ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f1f90266bd82966f0c10906ed5f9ddc2d595c6d91795634fb6c2d9f3a5c2450"
    sha256 cellar: :any_skip_relocation, ventura:       "8f1f90266bd82966f0c10906ed5f9ddc2d595c6d91795634fb6c2d9f3a5c2450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a594473a99308780ad167e0ba93fd19660776800eb0948b21789f572e873de9f"
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
