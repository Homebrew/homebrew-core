class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "9673cbeda432ab06a964d259f15c4d5b45cf2bd1fde9b1d94134bcc6bd5082bd"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff49cd051a8f1e85c658649d6f60d58025a3ea406c76d045c1d79cd0e228dde2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff49cd051a8f1e85c658649d6f60d58025a3ea406c76d045c1d79cd0e228dde2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff49cd051a8f1e85c658649d6f60d58025a3ea406c76d045c1d79cd0e228dde2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2616cdac1c5d9b029d874d60b2a4330d9c8ba79c9c9f2a12a25082b32ff79acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04451de16dadbed988f4f4de7c0492670e0f5f4f982d2d305f2fab290c800e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfa0e580253f1c7434b58d61250a6532a200cab22145e5f9c989ca56ba4d6674"
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
