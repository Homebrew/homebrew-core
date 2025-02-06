class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "7b9234d407a8ceff2d928ed4839d9bdefe457cf4762053672cc4031295999b28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b49b9a77334df4b6421e326e9326fad1a56665ba3378cc08ab37caaaab70d75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b49b9a77334df4b6421e326e9326fad1a56665ba3378cc08ab37caaaab70d75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b49b9a77334df4b6421e326e9326fad1a56665ba3378cc08ab37caaaab70d75"
    sha256 cellar: :any_skip_relocation, sonoma:        "b388fbca2c7c6648cbeb23a1e8867122feefc4b0a711a21f20181a4d5b52ec9e"
    sha256 cellar: :any_skip_relocation, ventura:       "b388fbca2c7c6648cbeb23a1e8867122feefc4b0a711a21f20181a4d5b52ec9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b8ec334b7091630aaf70a3c2a2b3d30d601c54c4665dd12ba168e0e318ca42f"
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
