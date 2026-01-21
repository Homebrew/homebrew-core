class Karakeep < Formula
  desc "CLI tool for self-hostable bookmark-everything app karakeep"
  homepage "https://karakeep.app/"
  url "https://registry.npmjs.org/@karakeep/cli/-/cli-0.30.0.tgz"
  sha256 "c262313c828f8f7676b440d2183478567c31e9712f71b547717267747ce859a4"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d5d3a2a129d3393449741d26fbe625c50c002c7cbfcb0255b783a6ad0b334db5"
  end

  depends_on "node"

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
