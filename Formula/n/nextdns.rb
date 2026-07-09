class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https://nextdns.io"
  url "https://github.com/nextdns/nextdns/archive/refs/tags/v1.47.3.tar.gz"
  sha256 "73a57ff41074d32a7707b751da36c0a618edc6d2b41ddf61ca565222448f567b"
  license "MIT"
  head "https://github.com/nextdns/nextdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "014bc8b37811f6bc5827936cd4feda6ffcf0fa563d198fb0be2248103ad262a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac0d0c58752f5b475ea139c3446d3c38746f7b7825ffd1242fa79e4d0f4a085a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16174e0a63ffa8467741da34813bce6beacca3e474cccd8dfe2c991021f60021"
    sha256 cellar: :any_skip_relocation, sonoma:        "532df804d80b99bb2af239319aa012329056b836cd21ffd17fb21daa33115ca3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c0321ff4398c2474b71b737976b25b85af487f7e55e333f52b76df41dcdd2f5"
    sha256 cellar: :any,                 x86_64_linux:  "e9157dc82c5316d0412345a47d8e750c366cf5fa79dbffa6cb1cf7f6f68f6e8d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nextdns version")

    # Requires root to start
    output = if OS.mac?
      "Error: permission denied"
    else
      "Error: service nextdns start: exit status 1: nextdns: unrecognized service"
    end
    assert_match output, shell_output("#{bin}/nextdns start 2>&1", 1)
  end
end
