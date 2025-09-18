class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "fac913a29e8a12408819a5e036d264d2e31a9bd3baee48ad02dbdd8e04e2f91f"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be454c25e7c873cb227a947a19bc40129e6608483114d6e4fa0205ad0c5d2fd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be454c25e7c873cb227a947a19bc40129e6608483114d6e4fa0205ad0c5d2fd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be454c25e7c873cb227a947a19bc40129e6608483114d6e4fa0205ad0c5d2fd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be454c25e7c873cb227a947a19bc40129e6608483114d6e4fa0205ad0c5d2fd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "04bc2d81fd2004bfc8c9a2187d795807de89d347ca7338bc1d3307732256d62e"
    sha256 cellar: :any_skip_relocation, ventura:       "04bc2d81fd2004bfc8c9a2187d795807de89d347ca7338bc1d3307732256d62e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58f5e7a2435a994fd1a08f94edf7abc8d7e68add6c2a2cd3dff8ef330c92359e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")
    assert_match "hello from the nostr army knife", shell_output("#{bin}/nak event")
    assert_match "failed to fetch 'listblockedips'", shell_output("#{bin}/nak relay listblockedips 2>&1")
  end
end
