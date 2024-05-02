class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "8a671bea7f085e8150e2f617f78ce6d583ea21f3a50cbc328e29d0d97dddfb6f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c800bcfc8b3e8870ec5267ff78cc60972f0722af412a997fbdb79b19d048105"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c800bcfc8b3e8870ec5267ff78cc60972f0722af412a997fbdb79b19d048105"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c800bcfc8b3e8870ec5267ff78cc60972f0722af412a997fbdb79b19d048105"
    sha256 cellar: :any_skip_relocation, sonoma:         "a14bd6262c693da36d151bd8be9e88bc60dd0ce6c9ac38d786812d4b859f7f1c"
    sha256 cellar: :any_skip_relocation, ventura:        "a14bd6262c693da36d151bd8be9e88bc60dd0ce6c9ac38d786812d4b859f7f1c"
    sha256 cellar: :any_skip_relocation, monterey:       "a14bd6262c693da36d151bd8be9e88bc60dd0ce6c9ac38d786812d4b859f7f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eb9ac3d48fa9c984399dc2fd2246dd64d21c504eca6fa14dd527041202f5421"
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
