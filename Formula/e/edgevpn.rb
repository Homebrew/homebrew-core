class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "9e73ac38827d15fa19b6c6b9fd9794a53aafcae744730142dde9db40f332f73c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08672aa07398ab0b8c18a48c0a855999db94970da78abbfacc710b2616a93ab3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08672aa07398ab0b8c18a48c0a855999db94970da78abbfacc710b2616a93ab3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08672aa07398ab0b8c18a48c0a855999db94970da78abbfacc710b2616a93ab3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5fe88cc7955aeb32011e71ac40b38998a3a7e53101d4c4e84936e7881632ee0"
    sha256 cellar: :any_skip_relocation, ventura:        "d5fe88cc7955aeb32011e71ac40b38998a3a7e53101d4c4e84936e7881632ee0"
    sha256 cellar: :any_skip_relocation, monterey:       "d5fe88cc7955aeb32011e71ac40b38998a3a7e53101d4c4e84936e7881632ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c81b18de7c408489046c7cdc9e0bc7ca0ad3371d9b4598e25cfab3c5d9e6bcb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    generate_token_output = pipe_output("#{bin}/edgevpn -g")
    assert_match "otp:", generate_token_output
    assert_match "max_message_size: 20971520", generate_token_output
  end
end
