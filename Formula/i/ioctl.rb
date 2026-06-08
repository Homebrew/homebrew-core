class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "520f9d38bf4da310727d23c3874b78e5bf23554bc71adfb4637904f5e5f54a70"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e6d063c3c375b73a0cb073b1f0e0324a69b9816ea2d5d02ee082f6fc4b8ebcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3d53a8f9e100858028169b9886d8ed811d35b920752619b77702fef46b06765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b3a0c02ed21306db3288c18e8cfb62bb32bccf101f4900529919d8d02143c82"
    sha256 cellar: :any_skip_relocation, sonoma:        "790a51cd9a5cd787334ba35c48d86eeeb2f084c6754ef84b0a2792f83f845fdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "026eb62ca97dbb795ba2225e94ead110bec0cb9232fe2123e6e251d97f558bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d73bf84d52427ddfeebfba192ce195221187ac8de7f47fa44952a865f47146fd"
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
