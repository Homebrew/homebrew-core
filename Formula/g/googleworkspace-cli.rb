class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "0a3742286afd2da00ace59992ff04cef881c46ff720730ac58baee455be1209a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68c644338a5aefbf23895e0614fc9a3e142b63e403de2850fb2c43e9d652b40e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f94dc1715c18c7081407544c226be3996f9da2e5aaa3cd9f41921b65e4d94ea7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae115cd8ba0fd503e8416ef7d58eb5b4c38a8976a2c86a02ef22aea4f8f8347f"
    sha256 cellar: :any_skip_relocation, sonoma:        "23495916701736d0dd8d322a974c05a6703fbfb85c3f9e060fd1afba97aa4702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af5ab47d5b02d31d7a258a1abac3233382b0912317a8e908e0e92f7405ba76fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d39fc25189ddb53d78dbfbf013a66bdfd15fb317d5452b33037fbfd72e2c5dd0"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 1)
    assert_match "Access denied. No credentials provided.", output
  end
end
