class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "3e4a7314202324c7c5cbc9a4dff7e531745f93f259ff30f8f8b6a70d267ccd71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fe6cdb52c06a6da5de13c22bfe33907421397c8883d06d8ae08752581d31ef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fe6cdb52c06a6da5de13c22bfe33907421397c8883d06d8ae08752581d31ef1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fe6cdb52c06a6da5de13c22bfe33907421397c8883d06d8ae08752581d31ef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "041d5787ddd96ddb4d35ea4df4214daaee53b2a67f03a6c3ded88369724e0b54"
    sha256 cellar: :any_skip_relocation, ventura:       "041d5787ddd96ddb4d35ea4df4214daaee53b2a67f03a6c3ded88369724e0b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38331ad0b20a1711b49c4123f8eea8e663557097bcabf019f7bd7a8771a55eda"
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
