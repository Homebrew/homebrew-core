class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.6.1",
      revision: "6ed6264f1c4efbf84d310a104b57ef1bc57d57b0"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f8f972a8ef652e478457c2cf263bfb579911d3d128241ddc8d9299a7999393e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f556e510d497187a4db3bd0c2cdc612b327db765e8dc482a42ce69f6891dc7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe49cd7db5b5ea342d73c513a65c5a52e448e578acb817e66e179587cfab059d"
    sha256 cellar: :any_skip_relocation, ventura:        "57b8c443283536db82ffaf9b3f7ef82d6ab4377f7a440a59ba99520c349f1db1"
    sha256 cellar: :any_skip_relocation, monterey:       "a5469e730ae7bcbefa0064eee4d4610de9003efb58e6fd8e81061f342579f873"
    sha256 cellar: :any_skip_relocation, big_sur:        "10de8a4a45d44d075ca5b124be5e7bd6e2ef33380c3d9654d8f504487194139e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5e93b78f6273a8adb0c04998668a6452586ef92fe90071924b91a6329ea3bcc"
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
