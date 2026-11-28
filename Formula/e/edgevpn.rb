class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "b7bab4833cd651973aa54241d6516f6d91efe97b67f98704634e479e13e7d30c"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    manifest_sha256 "a870a664063b87c36fcf98f707291b6bdc34b2c3f22a9e6e3a83dcb3ccb58dfe"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "41a0c7ae7965f3304991d5352e63aa7c0dd5b665c2e2cb50eab4e4b1c9db7123"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41a0c7ae7965f3304991d5352e63aa7c0dd5b665c2e2cb50eab4e4b1c9db7123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41a0c7ae7965f3304991d5352e63aa7c0dd5b665c2e2cb50eab4e4b1c9db7123"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5de47928dbc2ce65ae5bcbcb0086f440d1fcbaac62c8c0efac65b0576ab9ee07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c6daf89f3d9db8828b1ec21b0c94d62b866fb70fdff91e1b01133206663c80bb"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    cd "api/react-ui" do
      system "npm", "ci"
    end
    system "go", "mod", "download"
  end

  def install
    cd "api/react-ui" do
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
