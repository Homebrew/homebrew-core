class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "99dc073f38b019fb4e6f5645825db516277081e8541aa059ff902417dc363061"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76007fba59ff05de837f064dd68cfd063798f4a59998382936627b245eabd7d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76007fba59ff05de837f064dd68cfd063798f4a59998382936627b245eabd7d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76007fba59ff05de837f064dd68cfd063798f4a59998382936627b245eabd7d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6292326c92b8e579250cc26c5b8a72fa9d74f5a0a42f617d33c3a8e4933b78b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f58b999c46e294f0bb042920e0426d851beeb480904b93e22e2a3f43aeab323f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "288086b33bf2fc193a9d61ec1c69373f754221385d6c27895444ae704104b5fd"
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
