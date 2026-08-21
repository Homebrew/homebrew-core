class Firefly < Formula
  desc "Create and manage the Hyperledger FireFly stack for blockchain interaction"
  homepage "https://hyperledger-firefly.github.io/firefly/latest/"
  url "https://github.com/hyperledger-firefly/cli/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "f9c73ca146af0e9e5ed5ef68d45c5733375f211233e5093ca060c9ddf8587f0b"
  license "Apache-2.0"
  head "https://github.com/hyperledger-firefly/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23c8e358bda21f179ff5b0211f8bb73012c83d5816b021e2790ce46b9dc291c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23c8e358bda21f179ff5b0211f8bb73012c83d5816b021e2790ce46b9dc291c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23c8e358bda21f179ff5b0211f8bb73012c83d5816b021e2790ce46b9dc291c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b98f995fef6046fcc4ed494b3f65f9b08f7b865403dd96b7d6959fe8e71ffb86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d1ca0dd7e52c722e28ae10497c666f041da2146f2af4874cd878ab03aaf6840"
    sha256 cellar: :any,                 x86_64_linux:  "21ba828d9e926050090303fd2aff9d3a503d1f7775e7020b896ae73537b7bb03"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/hyperledger-firefly/cli/cmd.BuildDate=#{time.iso8601}
      -X github.com/hyperledger-firefly/cli/cmd.BuildCommit=#{tap.user}
      -X github.com/hyperledger-firefly/cli/cmd.BuildVersionOverride=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./ff"

    generate_completions_from_executable(bin/"firefly", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firefly version --short")
    assert_match "Error: an error occurred while running docker", shell_output("#{bin}/firefly start mock 2>&1", 1)
  end
end
