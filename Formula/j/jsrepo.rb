class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.7.0.tgz"
  sha256 "f1a9f782cd69befef82a34c0e20b133e232080357aee8cd79cacbaa516db2e7b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "556ba035c142ec15320e9d9d64c6962fce9f659a0f09b4de5e69aa27e7d283ae"
    sha256 cellar: :any,                 arm64_sequoia: "af1cfe3738c6e7ac63a0525591b5831dd46d23e7bfaba85cbe7a5a515fc194e6"
    sha256 cellar: :any,                 arm64_sonoma:  "af1cfe3738c6e7ac63a0525591b5831dd46d23e7bfaba85cbe7a5a515fc194e6"
    sha256 cellar: :any,                 sonoma:        "fbc7539e6ab9689d707a43913afcffc478dfdd6966220aeb1e10ec38da9e6f87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df4bf99681249d9f2159a45b934faf9fcb09985d76b88bef97b0fa245fe67950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a41f21fac9bfc8116b20ba16dbf5698cf63e0a2ccf14d1123e1a3466972475"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end
