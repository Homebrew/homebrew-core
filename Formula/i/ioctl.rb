class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "acc4857291562a5b9e6b682c576979a421a82e35051208ec0f58f0722ff7225c"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87de3fe41ab375b9da0a01c23d2e6f7f9675dee117cb73823682ffc7125c278d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b150f055de204411b2cc0fec976ddf3bae84a2b723313b22078ff68edda1dcea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5db04645d06ee1f79aff232a4c8d3a007ab73c5359b392ba701d7b3b989375a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2a5fc0cbf8cbe0fed8f1b5263fea5d5de85fff47a048f03ce4564afa0b14b10"
    sha256 cellar: :any,                 arm64_linux:   "eedc90138b890cf30295c3b3da9690937a08b85cdc980f2bc717ce49d77f938d"
    sha256 cellar: :any,                 x86_64_linux:  "fe2a1f25840d8bab00e6bc400e8926e2996e1def38e462f27645a522db9bc7f2"
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
