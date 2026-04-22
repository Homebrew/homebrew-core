class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.32.2.tar.gz"
  sha256 "9e0dec7937143d0cf1f728e3c15ef93a1d6ef1df4f19e87f5eee88d29baf0a13"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf99407a6b02090bd8ad5f317d0139f39837eff9cc72f5e7cc67a8addad2e82a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf99407a6b02090bd8ad5f317d0139f39837eff9cc72f5e7cc67a8addad2e82a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf99407a6b02090bd8ad5f317d0139f39837eff9cc72f5e7cc67a8addad2e82a"
    sha256 cellar: :any_skip_relocation, sonoma:        "087a826a5f114bfc080e37a27e53d14f276f3a81b0f33970b58c14ff6f4ffbbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb19556b9a7413243dca6cbfd9625e675f0646593d855534d7c1838a6a69403e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a7dc1f3171fb98127c0c01a50c87934da2250566ab8d3db36d1959de0d9d9ba"
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
