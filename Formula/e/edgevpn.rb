class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "2ef04fe40b523cbf5d241afa8e6782f35583b0f948751f51a667e6d7751cdbc9"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f263d494ad08bd197f86fc89b47855caae6ec9213e4067eeede1ecc849726a25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f263d494ad08bd197f86fc89b47855caae6ec9213e4067eeede1ecc849726a25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f263d494ad08bd197f86fc89b47855caae6ec9213e4067eeede1ecc849726a25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "39ce6a49acc0dd5912e8d6abaf1cf627cf1e8f93c06b3c387eab688e2fd24c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "22f2297e6f09bfc798d1ef56b4a22f88b996fc208fe461302eb74e006604b82f"
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
