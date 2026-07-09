class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "99ed68f7473d347f4c793051eeaa7a7247920927f33d94d4279cadb69522be48"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96f06af2bbbb263f63e6e3a2bac477c432f08c3d090d9228676169c047e34fe5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed567cca84d4e44c2f285e34c709f5e6c4d98ab2c158bea8bd4111d4bd5b1d13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67b9ff8b6e9b79e6e6e593dbd52de92bc1bacbb732d1907aef08183a1224f68f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e7f4e9995220f0fe795bd046e77284d4bb3cd7c67aa1aac8347b68689078e2f"
    sha256 cellar: :any,                 arm64_linux:   "93319621c95c2f6a690f94eae3fc4946cb41465158875ec1acba9687a6fe0f02"
    sha256 cellar: :any,                 x86_64_linux:  "8b2e1ab13aa9373f18cc092dd9d65a2ab4bf8aa192f79a572ba17afbca1b4cdf"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X github.com/iotexproject/iotex-core/v2/pkg/version.PackageVersion=#{version}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.PackageCommitID=#{tap.user}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.GitStatus=clean
      -X github.com/iotexproject/iotex-core/v2/pkg/version.GoVersion=#{Formula["go"].version}
      -X github.com/iotexproject/iotex-core/v2/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "nosilkworm"), "./tools/ioctl"

    generate_completions_from_executable(bin/"ioctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ioctl version")

    output = shell_output("#{bin}/ioctl config set endpoint api.iotex.one:443")
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
