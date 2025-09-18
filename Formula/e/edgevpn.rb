class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "94ef7b49be8262483f6836057b852c9c06b62ff4fd96ff78c3fd623c211d1f8a"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8603cf57fb08f8f246e29d5ab17b9d8e86aba3473f0782175702d1f7d1d55c05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7bf0ccaabe9e8b3606f2c5bf4c527962f007c431da9c27ec7f9593f8a4f4c95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7bf0ccaabe9e8b3606f2c5bf4c527962f007c431da9c27ec7f9593f8a4f4c95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7bf0ccaabe9e8b3606f2c5bf4c527962f007c431da9c27ec7f9593f8a4f4c95"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b0442deb1c7aac7605ed17bc153ef8f29b8c719eebd3facf80fa6bfe418ee62"
    sha256 cellar: :any_skip_relocation, ventura:       "1b0442deb1c7aac7605ed17bc153ef8f29b8c719eebd3facf80fa6bfe418ee62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d6e4d5a1a8727c34d12be5edf4e7cfb7189348f4047ba7ae8bee270f63274f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3b7a86b365657b4243ede4f7ad16df1cc42882c20cf6f89498b17d7cf114cb2"
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
