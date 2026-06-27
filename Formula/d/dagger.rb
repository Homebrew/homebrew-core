class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.21.7.tar.gz"
  sha256 "f6b5e327f0fb51f4b8407a925df1d29b1ac3b1a32ff924c65da17f04176d7f9d"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5008a2d25a6c2017dc99c52f01945bbbe4c575a9d2da6a94aa6b72921f24b166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5008a2d25a6c2017dc99c52f01945bbbe4c575a9d2da6a94aa6b72921f24b166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5008a2d25a6c2017dc99c52f01945bbbe4c575a9d2da6a94aa6b72921f24b166"
    sha256 cellar: :any_skip_relocation, sonoma:        "91c16369880adb29326fb4894884791540fd80af8651875a13a68f893d490949"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7b8a0e8beeb2eb673358e0b3642d031a98b2921f58554e8b35561b5f8245d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b856a9bc7fc5c29e0b48364bcac9030fbd67c8f483f2137978638e68a2963e8d"
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
