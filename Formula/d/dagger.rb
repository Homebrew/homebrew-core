class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.18.18.tar.gz"
  sha256 "41ea09d61d4769f537b0cbcf24918e51c119afc3586e01e6c6f61856731cdb7d"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb026d2253819d127b98c7e7450dfc481bd5c4af43baaeaa57da48f355b5755e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb026d2253819d127b98c7e7450dfc481bd5c4af43baaeaa57da48f355b5755e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb026d2253819d127b98c7e7450dfc481bd5c4af43baaeaa57da48f355b5755e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c6bdbf50dd0c2932d113987703db884e1cab618a66a6b98614ecfdf9804c5ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5dede36568d3e3d52bac5ce21077075044957738e2d4b87f476bbcc3b8cdce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6b88d344a5ab72767c2e013bae7f1740a3e6eb8c079c663d2fca82deb1d5bf1"
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
