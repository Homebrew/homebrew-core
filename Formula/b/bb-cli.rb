class BbCli < Formula
  desc "Bitbucket Rest API CLI written in pure PHP"
  homepage "https://bb-cli.github.io"
  url "https://github.com/bb-cli/bb-cli/releases/download/1.4.1/bb"
  sha256 "ed7aa1861743aef75782865461bb03bcc0cfd29231d29dc882a59fb7c4189048"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9103b2f8975990a2d66486c6e1e0b7432393dfdee1477393f5b8e8d2f28471c8"
  end

  depends_on "php"

  def install
    bin.install "bb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bb version")
    assert_match "No git repository found in current directory.", shell_output("#{bin}/bb pr 2>&1", 1)
  end
end
