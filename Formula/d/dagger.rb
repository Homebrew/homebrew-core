class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.19.6.tar.gz"
  sha256 "117ae4f51d1c6699dfd5bf404ffcc1078daec50dd637a1a7aea55c3ed8f30fa4"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2815c9875bb3e9ccbb1ba680d5c27aa00fd429b76e0536eb81259432d8c0b2f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2815c9875bb3e9ccbb1ba680d5c27aa00fd429b76e0536eb81259432d8c0b2f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2815c9875bb3e9ccbb1ba680d5c27aa00fd429b76e0536eb81259432d8c0b2f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f44ebe9bc7ddad9da53998498daf110b7004ae72e9330f2bb734267a0a1661c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3446e7ae339519e6cdb8b68c82dd9218da8035990b41a656f27ff823554b1297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d425527ab2259be1a25659613ea86c2947ef6ee9203016162ed16ea05c8b9439"
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
    assert_match "failed to connect to the docker API", output
  end
end
