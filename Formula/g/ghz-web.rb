class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/refs/tags/v0.120.0.tar.gz"
  sha256 "e058b1dc3aa09ca7594a79f92bad3b481c4193a0db31b2ac310b54ad802b2580"
  license "Apache-2.0"
  head "https://github.com/bojand/ghz.git", branch: "master"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "85e63d579de011ba7228496524c9f59ee04757da8b7af3b2908f02aa0e412627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "41a6553616554277541ebff12075da8d72be1d17bb21f9608785f09de3c00710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4aaf95d9bb2d035676ce06f3b6650eacfdd5c149e771dbf4e26f3881aed47c6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88cdd543eb268e47d62dcc27a67a620071b3842b53bdcdeb975aa5357550523c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcaa8c8a1f4648b9eb480a316275d3499e6ae93aca2167ea98a8a6a82a206d4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fdce463dddf22e4cf8e452f32f60a5e9eff0d53f05a5886434d80cb4a4f1e4a"
    sha256 cellar: :any_skip_relocation, ventura:        "f33d047cb7a064c954fe807f2bd6c47ccb366264d7a2f98ac497e889b7b5c7ba"
    sha256 cellar: :any_skip_relocation, monterey:       "aa8bc7a1d646ea1bac570b39a534cb2f71195e7acc60c85d42895cb1d64e7b81"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9f8acbd9fae34cb9532113a0b32890ea8967f6636dd1003605018695d38939bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26e58f6d58a9c1549952092b2a5518409b2c7aac05540446f7ea42f589f3492b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ghz-web"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec bin/"ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end
