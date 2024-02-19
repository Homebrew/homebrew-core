class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.9.10",
      revision: "88a813f01b578c876ca1e5ee7c06457127a49fb6"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5980a2a6d10c6b96f6125d423f4be206fda0108391dc1275e271ffbc27f8e87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32848694ec877b6e669cfc6224eb6746cd53291110ad8881c69cb8990d5dda84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b1e4c2f0f56b9b8fba4cdd7dae2302f18dfc9b70e50949570126dba89311db"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7817952dc2c757faf6f752eba0dc0bc7366061071393580e4c1cf2c94cabac2"
    sha256 cellar: :any_skip_relocation, ventura:        "a31e5709623f623e97cdef3c8aed312c3a1a5a3416662a49ea9147be0765623d"
    sha256 cellar: :any_skip_relocation, monterey:       "2338e16fa274f2c28d6521da883e6aacbf3336f86eac40dff61d0dfb1b3a8799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb0d96f5d0c8ec4416c30321666f54280ca4230fcb61efdd0dea72177c92ac58"
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
