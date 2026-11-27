class Karakeep < Formula
  desc "CLI tool for self-hostable bookmark-everything app karakeep"
  homepage "https://karakeep.app/"
  url "https://registry.npmjs.org/@karakeep/cli/-/cli-0.35.0.tgz"
  sha256 "ed03903db20b24f6a26c01b91956dc264a4a5d1b34fd6d8fe5ba1d2a1fd5402b"
  license "AGPL-3.0-only"

  bottle do
    manifest_sha256 "6e8dee8f9ad8de39bc2884ffa1543c831d040935e7fb59c0c4855ac7ecb5e129"
    sha256 cellar: :any_skip_relocation, all: "14a6f3c548a2d97bd1926d5ae122d166aa72d074a3811a6011e3b1b1711c6532"
  end

  depends_on "node"

  allow_network_access! :test

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/karakeep --version")

    ENV["KARAKEEP_API_KEY"] = "invalid"
    ENV["KARAKEEP_SERVER_ADDR"] = "localhost:#{free_port}"

    assert_match "Error: Failed to query bookmarks", shell_output("#{bin}/karakeep bookmarks list 2>&1")
  end
end
