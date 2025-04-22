class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "7475d887f172ae0890d469dc1e584feb90e55535923ca3ecf2c45e53f8f50b3c"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cacf6f0b6f40719a2c144fe6fa654cd9c822e7ec5ccc21eebf49a3b81a4716c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cacf6f0b6f40719a2c144fe6fa654cd9c822e7ec5ccc21eebf49a3b81a4716c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cacf6f0b6f40719a2c144fe6fa654cd9c822e7ec5ccc21eebf49a3b81a4716c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb1df2c9bc9ceee0ac90c31b5aaffd4cb9ec6a614475b6f0615141ae4c02a949"
    sha256 cellar: :any_skip_relocation, ventura:       "cb1df2c9bc9ceee0ac90c31b5aaffd4cb9ec6a614475b6f0615141ae4c02a949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08bd417d012989c03343b52af9e121e5a75dd8810f7f7f84c4cb6777923fed54"
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
