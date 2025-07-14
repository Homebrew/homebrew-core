class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "67670a0a4107ed65371a8b310bfbf832996a57f832edebef7fac28d637a82ee9"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4b38de21c0bca69d84547c94511148cddbafbfe90f5d88cf4cea8708c977dbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4b38de21c0bca69d84547c94511148cddbafbfe90f5d88cf4cea8708c977dbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4b38de21c0bca69d84547c94511148cddbafbfe90f5d88cf4cea8708c977dbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b45d5adf4067cf6eff2a05795c25d895b3ba6ccdf2a6fe09dd661f756b4646d6"
    sha256 cellar: :any_skip_relocation, ventura:       "b45d5adf4067cf6eff2a05795c25d895b3ba6ccdf2a6fe09dd661f756b4646d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c0cc718f4e0014f7f939db5fb2448b3e6cb7f0b5077d3e90cdc53e34a543bb0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")
    assert_match "hello from the nostr army knife", shell_output("#{bin}/nak event")
    assert_match "\"method\":\"listblockedips\"", shell_output("#{bin}/nak relay listblockedips")
  end
end
