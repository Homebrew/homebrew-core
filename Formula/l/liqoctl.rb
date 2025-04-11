class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0fc334ed6a1f0b7afa337b6a76796c1485e93af9cdd35c562fc52136b32611bf"
  license "Apache-2.0"
  head "https://github.com/liqotech/liqo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcad183bb34ecb46edefd59e25cf15c4552e932d7f4cb569de63378f53f07786"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcad183bb34ecb46edefd59e25cf15c4552e932d7f4cb569de63378f53f07786"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcad183bb34ecb46edefd59e25cf15c4552e932d7f4cb569de63378f53f07786"
    sha256 cellar: :any_skip_relocation, sonoma:        "96949d366b79720d97ce1522d92f85b8b6ab4b8ab0db7d463876a07c6d583c1d"
    sha256 cellar: :any_skip_relocation, ventura:       "96949d366b79720d97ce1522d92f85b8b6ab4b8ab0db7d463876a07c6d583c1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a01acb84b85d5daff6c3ec55240259e19e3b9dfaa83fab447342f0d2e00a1c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9296a3d5c4b001e8fe66fddc076dc06f6044bea2a1d985b54c74f5d0acb0894e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.LiqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", "completion")
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
