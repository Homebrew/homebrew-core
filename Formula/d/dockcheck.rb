class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https://mag37.org"
  url "https://github.com/mag37/dockcheck/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "17c7141f470786eb9a63c4b8ef58aa7efc43a76e6907df52a598ec0d04dd796a"
  license "GPL-3.0-only"
  head "https://github.com/mag37/dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37f2b2bb4a0b6d5c9106486e476974702dd1d2f1bcae44d940095555e2a41e35"
  end

  depends_on "regclient"

  uses_from_macos "jq", since: :sequoia

  def install
    bin.install "dockcheck.sh" => "dockcheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockcheck -v")

    output = shell_output("#{bin}/dockcheck 2>&1", 1)
    assert_match "user does not have permissions to the docker socket", output
  end
end
