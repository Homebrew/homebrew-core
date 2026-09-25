class HerouiCli < Formula
  desc "Command-line tool to manage and initialize HeroUI projects"
  homepage "https://github.com/heroui-inc/heroui-cli"
  url "https://registry.npmjs.org/heroui-cli/-/heroui-cli-3.0.4.tgz"
  sha256 "b5da92be0986b185d74b92f4e3a202c4c75ba83616e32f203d81067a7ad107fb"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/heroui --version")

    (testpath/"package.json").write <<~JSON
      {
        "dependencies": {}
      }
    JSON

    assert_match "No HeroUI packages found", shell_output("#{bin}/heroui list 2>&1")
  end
end
