class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "2ef04fe40b523cbf5d241afa8e6782f35583b0f948751f51a667e6d7751cdbc9"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "218b996f1bbf09395150514fd09da39bc43d6b278071eb056acdff61d9bcfa3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "218b996f1bbf09395150514fd09da39bc43d6b278071eb056acdff61d9bcfa3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "218b996f1bbf09395150514fd09da39bc43d6b278071eb056acdff61d9bcfa3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1b6bbd06c990d2f38962007fb803ea85afc7422d7b88672298f75e20a826c7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "de28a15c0e532c459f82aa038cc096e401fc35c75d884fc95160c9e38ed488b7"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "api/react-ui" do
      system "npm", "ci"
      system "npm", "run", "build"
    end

    ldflags = %W[-X github.com/mudler/edgevpn/internal.Version=#{version}]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    generate_token_output = pipe_output("#{bin}/edgevpn -g")
    assert_match "otp:", generate_token_output
    assert_match "max_message_size: 20971520", generate_token_output
  end
end
