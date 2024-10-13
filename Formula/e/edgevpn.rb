class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.28.3.tar.gz"
  sha256 "266e436fab3ecd322c0753a7592b6be862ce1e44d31c4282edac5ddccb8057be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9717cea2975a02761489cb7dabba9547d8da7bfde74f272e4be05fcf69e005e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68cdccdf9dbcf1b161a7931699caeb7825237a7012ae4288ed0222361a397042"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68cdccdf9dbcf1b161a7931699caeb7825237a7012ae4288ed0222361a397042"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68cdccdf9dbcf1b161a7931699caeb7825237a7012ae4288ed0222361a397042"
    sha256 cellar: :any_skip_relocation, sonoma:         "38c7d12310b09c737b49da4228ed97b7cfc27882e2e7abdd7842fd0aa622b29b"
    sha256 cellar: :any_skip_relocation, ventura:        "38c7d12310b09c737b49da4228ed97b7cfc27882e2e7abdd7842fd0aa622b29b"
    sha256 cellar: :any_skip_relocation, monterey:       "38c7d12310b09c737b49da4228ed97b7cfc27882e2e7abdd7842fd0aa622b29b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8712e4c349b3ae6182dd5d19dd057cc87e62633a2fdd57fe9afd929ce1519261"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mudler/edgevpn/internal.Version=#{version}
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
