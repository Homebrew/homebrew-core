class Brewman < Formula
  desc "Cross-platform cleaner for system packages and node_modules"
  homepage "https://github.com/Zouziszzm/tools/tree/main/brewman"
  url "https://github.com/Zouziszzm/tools/archive/refs/tags/brewman-v1.2.0.tar.gz"
  sha256 "ff37f9f37b9e814d4e90be4c25f929f1164919f063c6cb85bdf26faf9e29e93c"
  license "MIT"
  head "https://github.com/Zouziszzm/tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^brewman[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "node"

  def install
    cd "brewman" do
      system "npm", "ci"
      system "npm", "run", "build"
      system "npm", "install", *std_npm_args
    end
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/brewman --version")
    assert_match "scan", shell_output("#{bin}/brewman --help")
  end
end
