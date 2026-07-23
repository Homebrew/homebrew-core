class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.35.3.tar.gz"
  sha256 "bb83fb66c78eba14c6b76091f652151458f0ed367d34de3a88f80c273e42ad77"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45bcf0058e96d64ed05497ad79e6afac738a7842c3b8bc1cc46d61377bdcee51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45bcf0058e96d64ed05497ad79e6afac738a7842c3b8bc1cc46d61377bdcee51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45bcf0058e96d64ed05497ad79e6afac738a7842c3b8bc1cc46d61377bdcee51"
    sha256 cellar: :any_skip_relocation, sonoma:        "87c440164485cf3214746869d080c16929ee773d7e7af143bdf1f3b10901ceca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e07eccc626e0f8aadc64282371500856fc6b7f52ea14a830b6cd9f05fd05026a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559c667051a94e44e174180f2d24c5feb5cebe5ea86fcdd61caef95585233b25"
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
