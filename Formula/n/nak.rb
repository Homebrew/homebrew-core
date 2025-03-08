class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "73eefee2c169df3b011e0e0922cfd81fa1ee0a0d6621df3aa23b50801451cab8"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "753d376907c5e714d91f8ace498adca54b564f560ee054e028bacfbb5e4cfe1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "753d376907c5e714d91f8ace498adca54b564f560ee054e028bacfbb5e4cfe1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "753d376907c5e714d91f8ace498adca54b564f560ee054e028bacfbb5e4cfe1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a2ba03a3bdd63fa45b8bdb58b4953a6f26d33c19ae61ce7a3b9706ad180adde"
    sha256 cellar: :any_skip_relocation, ventura:       "1a2ba03a3bdd63fa45b8bdb58b4953a6f26d33c19ae61ce7a3b9706ad180adde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d2cda4e48ddec5047383b563ca254bd22ce84b77d65db7c3bfcf6234ae662ad"
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
