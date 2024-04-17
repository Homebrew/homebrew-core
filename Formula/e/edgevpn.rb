class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "70fbc53e2d458de60a01c04d61aa3729378d4b954dcb5a56133e0cf8c7b597a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d4ac3066b10354a85585f58ba4f452ab66dee0a04181f249a0edcc5d0d2a876"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d4ac3066b10354a85585f58ba4f452ab66dee0a04181f249a0edcc5d0d2a876"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d4ac3066b10354a85585f58ba4f452ab66dee0a04181f249a0edcc5d0d2a876"
    sha256 cellar: :any_skip_relocation, sonoma:         "072d8c7f189feb197f9556130d4d6a28e09a22ced6df64e30b74d4d42f241a5b"
    sha256 cellar: :any_skip_relocation, ventura:        "072d8c7f189feb197f9556130d4d6a28e09a22ced6df64e30b74d4d42f241a5b"
    sha256 cellar: :any_skip_relocation, monterey:       "072d8c7f189feb197f9556130d4d6a28e09a22ced6df64e30b74d4d42f241a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce5feffc0561d24e640c6b2e3294d6bfebda494b8c32c7f8891a6d34ad43431b"
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
