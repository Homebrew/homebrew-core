class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.21.4.tar.gz"
  sha256 "70501cfc2f9c0c2610d5c062347ac2cf0cec2abd831cfeffd9c0aa27093b4439"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "341153b0cd83f910f9410f1cc491fb977136d017b5032dd1913664d3361c8b5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "341153b0cd83f910f9410f1cc491fb977136d017b5032dd1913664d3361c8b5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "341153b0cd83f910f9410f1cc491fb977136d017b5032dd1913664d3361c8b5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c1fdee7d4f9578062c1fd29e79ed318c3b51ba65f0850b7be1ab1c8fb5557b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fe26c444a05fc89a88bca89d90a58f9d18bd782e8e254576576392bf10cae0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9569a22c3f47f44277d5e9e940136e71ea2705bb2f5013ccf5d3dfe9992c914d"
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
