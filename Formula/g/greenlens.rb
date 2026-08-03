class Greenlens < Formula
  desc "Offline houseplant care, diagnosis, and light guidance CLI"
  homepage "https://greenlenspro.com"
  url "https://registry.npmjs.org/greenlenspro-cli/-/greenlenspro-cli-1.0.0.tgz"
  sha256 "edbe385dc46582502a0b51bc055faeb158023c50077789ea34654534ee3a5cd7"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "Care Guide: Monstera Deliciosa", shell_output("#{bin}/greenlens care Monstera")
  end
end
