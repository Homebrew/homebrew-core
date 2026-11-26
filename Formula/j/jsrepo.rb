class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.8.4.tgz"
  sha256 "bb906302fafc3919673e69e1ee3ed4c28a137db3973857789e25c423ae8fb233"
  license "MIT"

  bottle do
    manifest_sha256 "c56135d676d0813932031d8ff214087133aac330ed1620226e263f0563e2f120"
    sha256 cellar: :any,                 arm64_golden_gate: "fd18c4675c79d0b21d4553caca6211b92fa92aedea5d25b50149540a24c8f08a"
    sha256 cellar: :any,                 arm64_tahoe:       "fd18c4675c79d0b21d4553caca6211b92fa92aedea5d25b50149540a24c8f08a"
    sha256 cellar: :any,                 arm64_sequoia:     "fd18c4675c79d0b21d4553caca6211b92fa92aedea5d25b50149540a24c8f08a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "25d354c68e7d304b0412069c2f36f008473c9e28ab520bc3c761a3bca5335256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ef47aa8e734b1d0e7f2c2d50fbfc8ad7ad6fb5629414055cb386baa012a5e221"
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
