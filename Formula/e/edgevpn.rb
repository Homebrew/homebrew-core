class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.35.4.tar.gz"
  sha256 "9e792a7e171306eacca7b0d30c0ceb212885fcaf10969020eb0ba5c443e5f99d"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95ee4dd348959aa00f6620ca4465064bcb5e9f8bf34e6fcd68f5621d33a56343"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95ee4dd348959aa00f6620ca4465064bcb5e9f8bf34e6fcd68f5621d33a56343"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95ee4dd348959aa00f6620ca4465064bcb5e9f8bf34e6fcd68f5621d33a56343"
    sha256 cellar: :any_skip_relocation, sonoma:        "224d8b6ac48bf30b1f572a9148ba96f8ebae497370b5dc04fd4c30efd3f05fd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e07c925819de2393d836076466a94d31ca51e4a580b0b391a812688d09bf6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aab5b62897836e8c52ef01d003f27644cd053c9d18024701b9a465865243b36"
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
