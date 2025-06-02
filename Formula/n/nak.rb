class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "5d3d1688a36f16c5cb84cdd72298f54289309eb9d94d27b00e536329f8a26571"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d066ec1cc25006bc7dbc8cfc621b186e54c4f3f3a56415092a8f1c13573f4d9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d066ec1cc25006bc7dbc8cfc621b186e54c4f3f3a56415092a8f1c13573f4d9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d066ec1cc25006bc7dbc8cfc621b186e54c4f3f3a56415092a8f1c13573f4d9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ec7b2883d368e37643d6beb81cbca45c1794fbca9843777f512f271e7c85c7b"
    sha256 cellar: :any_skip_relocation, ventura:       "8ec7b2883d368e37643d6beb81cbca45c1794fbca9843777f512f271e7c85c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b921fec4e2af1eb83377b3db9e9999c3a9b8cdb5e7948477d735b4b65de4d180"
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
