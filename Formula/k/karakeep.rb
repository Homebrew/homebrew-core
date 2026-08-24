class Karakeep < Formula
  desc "CLI tool for self-hostable bookmark-everything app karakeep"
  homepage "https://karakeep.app/"
  url "https://registry.npmjs.org/@karakeep/cli/-/cli-0.33.1.tgz"
  sha256 "2fecaf6629923bdc26a98a5abf1e8a6d866432c3a08dd53de34f020c75472c53"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a491c1497b2112cb9740f140f7188bf4799bf992c4d18587ca77dcae120d41c3"
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
