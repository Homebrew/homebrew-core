class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "4628ded118fee1b9424b8fa480db989f8a2c751df3cafe3c5f76c14871435dbe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d40d6b39354487cb20df757bc32c2c7fff5f6a76e86526c24992f95745b70be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d40d6b39354487cb20df757bc32c2c7fff5f6a76e86526c24992f95745b70be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d40d6b39354487cb20df757bc32c2c7fff5f6a76e86526c24992f95745b70be"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3f82320f21002f9fa989511e2e044cd772efca7f9b17ca94347becc62fc72b6"
    sha256 cellar: :any_skip_relocation, ventura:        "f3f82320f21002f9fa989511e2e044cd772efca7f9b17ca94347becc62fc72b6"
    sha256 cellar: :any_skip_relocation, monterey:       "f3f82320f21002f9fa989511e2e044cd772efca7f9b17ca94347becc62fc72b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "896b8503a362b34a8eb9f8451838d0a5002ab8b2e2e59a9ac5afbf3805498476"
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
