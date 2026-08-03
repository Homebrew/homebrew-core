class MycliCli < Formula
  desc "Laravel Artisan-style development platform for Node.js"
  homepage "https://rutvik-sonani.github.io/mycli-cli/"
  url "https://registry.npmjs.org/@mycli-cli/cli/-/cli-1.0.4.tgz"
  sha256 "645a6c09d328da76dd4732df3141bd738e59065e7b582ff68a8ea7da9bf5220f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@mycli-cli/cli/latest"
    regex(/["']version["']:\s*["']v?(\d+(?:\.\d+)+)["']/i)
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["NO_COLOR"] = "1"
    assert_match "create", shell_output("#{bin}/my --help")
    system bin/"my", "create", "homebrew-test", "--yes", "--dry-run", "--skip-install", "--skip-git"
  end
end
