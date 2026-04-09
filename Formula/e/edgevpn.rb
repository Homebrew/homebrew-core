class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "3776af1f342a848e69687e14806cf5fa2597ab67679a2cec853955e255839106"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6ed1d56d4c7dcad71b09a6f0da9d39d7d9765c156eba7c53645439ce4cbe151"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6ed1d56d4c7dcad71b09a6f0da9d39d7d9765c156eba7c53645439ce4cbe151"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6ed1d56d4c7dcad71b09a6f0da9d39d7d9765c156eba7c53645439ce4cbe151"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9811e4a46a25942931666513e988540280bdb5edac00139cde0bb092443b35b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "550525f2d895b2f4ffab462712cb9861ca2324b2e43db2f2c6a387bf54a79932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "208794eaee47436e0664c6d7f3df3ce0178cac776203c95519a2029264eaae19"
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
