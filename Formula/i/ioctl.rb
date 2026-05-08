class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "20f347b590bc62de539d218401cc6b75a38dc2682b7f23acd6a7cd111b87af32"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93ad2095a8286b719a8fb1cc43db4fdfc70b40bc448231c99c9310d1c3fc6ab7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3351c79a63ac7556b53996946aa0547dca4e2b5c161524c17af2574ed70caca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8356dda522f7ada024c283d6c82a6ffd25d5136e6b430e7cad6c9eda9bfad9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e50b4e1b78cac3cce3c5371affc086656094a083f146952441eba7a2d20c9af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6e45493001fbcbd700be8fc6ed651ebaee9b88839c778710ab12aacc2c82b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95b1aa970e833dc99b81711d86687c98a86ea361c0e52358d04913b03e9b585e"
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
