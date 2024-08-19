class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.12.5",
      revision: "def01443251763ce702c8c0eb69d5de933b90e52"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfb408edec2132f781603ab453808a95a15465a1f6382b32b8a1320266d824f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4370e0e6a2837c7a713a309f9967edb40c4cc606171202387523c077da3e35a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "419ac36d3d3ca0da08cb6f31d4c83bdbff50afc8f58130055d2700f6c40eb07a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a06008bcb3c3acdb5e61bf36aedefeaca51736bce22cdfe29d798c27522572f3"
    sha256 cellar: :any_skip_relocation, ventura:        "ce8c69e2b8a9a7343e316193c5cc95f08e06c4b5da5b88d0abe345d650822290"
    sha256 cellar: :any_skip_relocation, monterey:       "433e3eb2adf8e8042e6b274e949cbb1d1d0a542911d47681c4e3f4fb521d725c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02a8e8b215c59853895e070964972c71d576997c2b2635e5b2282f0181040a96"
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
