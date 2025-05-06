class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "21e311c9690eada2a7e1e30b9dbc200fe9df8dc738c125c7f5c47d16c453a896"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2cf151662af07dd9e4c6a65dffdf63cdaab07ffac018084cea10f001e52e4d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2cf151662af07dd9e4c6a65dffdf63cdaab07ffac018084cea10f001e52e4d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2cf151662af07dd9e4c6a65dffdf63cdaab07ffac018084cea10f001e52e4d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5a1ffa9b9736aae84868962214ea5cfef60a0e637427a406a4fb87c686a64e4"
    sha256 cellar: :any_skip_relocation, ventura:       "d5a1ffa9b9736aae84868962214ea5cfef60a0e637427a406a4fb87c686a64e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4727d6cafb57c82b6895db76d26ec43cef0ca6d87b2e7e23b8ebe5c6a4737fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6872fd5382897a2ff306488f45b2e69ff2747a0cadc4e1e74d62c44eb8084279"
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
