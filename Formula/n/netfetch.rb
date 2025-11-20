class Netfetch < Formula
  desc "K8s tool to scan clusters for network policies and unprotected workloads"
  homepage "https://github.com/deggja/netfetch"
  url "https://github.com/deggja/netfetch/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "6029d93da6633a626d6920944825c76b5552e4ad5175101f661281e30b36b1cf"
  license "MIT"
  head "https://github.com/deggja/netfetch.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70e7ad4240c2e63c68c9d8090976aaf7be5268ef5c8eaba0ac9b78838e0c447d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f5ca9443c70310c77897987bdc5c8d285c8a86b718c4ef31fbbb7ad0f614f8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f5ca9443c70310c77897987bdc5c8d285c8a86b718c4ef31fbbb7ad0f614f8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f5ca9443c70310c77897987bdc5c8d285c8a86b718c4ef31fbbb7ad0f614f8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "66c0c77c648e2c97d1a785c7153dd7a3833cc225b42f6071934a2e3749f37b40"
    sha256 cellar: :any_skip_relocation, ventura:       "66c0c77c648e2c97d1a785c7153dd7a3833cc225b42f6071934a2e3749f37b40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a173e3dfac9e058b76f212cf75c19b9f2bf6c6ec0826f25c06a45f622afd1d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5901ca1bca581682e2c206cfc1eef3fca07861f82fe05b2a6fb614fcebefd33d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/deggja/netfetch/backend/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./backend"

    generate_completions_from_executable(bin/"netfetch", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netfetch version")

    assert_match ".kube/config: no such file or directory", shell_output("#{bin}/netfetch scan")
  end
end
