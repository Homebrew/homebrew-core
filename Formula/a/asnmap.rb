class Asnmap < Formula
  desc "Quickly map organization network ranges using ASN information"
  homepage "https://github.com/projectdiscovery/asnmap"
  url "https://github.com/projectdiscovery/asnmap/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "e29eddad2a760f012e6b33973d199d7a7f8ae0b3af72c84359c426b1b0cf639f"
  license "MIT"
  head "https://github.com/projectdiscovery/asnmap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da1aa64132b6210f87205e93d08eaefa27f7ec8119a4314b9a5ec0ce00905390"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da1aa64132b6210f87205e93d08eaefa27f7ec8119a4314b9a5ec0ce00905390"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da1aa64132b6210f87205e93d08eaefa27f7ec8119a4314b9a5ec0ce00905390"
    sha256 cellar: :any_skip_relocation, ventura:        "d5f54a85117decc28810bc4f95704ff4f7d6865cad41cd29927f24c02d4e8ef2"
    sha256 cellar: :any_skip_relocation, monterey:       "d5f54a85117decc28810bc4f95704ff4f7d6865cad41cd29927f24c02d4e8ef2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5f54a85117decc28810bc4f95704ff4f7d6865cad41cd29927f24c02d4e8ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "127a26e6a4b4712c01b2ae54d1099a2980e883ac9bc11aefb65a953afdd9f427"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/asnmap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asnmap -version 2>&1")
    assert_match "1.1.1.0/24", shell_output("#{bin}/asnmap -i 1.1.1.1")
  end
end
