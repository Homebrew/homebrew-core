class Dockcheck < Formula
  desc "CLI tool to automate docker image updates"
  homepage "https://github.com/mag37/dockcheck"
  url "https://github.com/mag37/dockcheck/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "fdd2040992e3c542f50c31f38c18f8631b1f9a53df9654dcfa74b33837a8ca8e"
  license "GPL-3.0-only"
  head "https://github.com/mag37/dockcheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9648794cea62cb77b723d8a7482a0c34fd482d52af41892c21b24ad585173b19"
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
