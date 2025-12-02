class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.0.5.tgz"
  sha256 "bcd03ab69be20c64c30ba74029fd8c585543315b600badde9b9291ac5eee2d94"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9823357c8b3affcfd31286baa29010a1446966b7a2edcfb0a2929d278ca41420"
    sha256 cellar: :any,                 arm64_sequoia: "f180790e8b767291efc084d4edf325f75a4c854a7aa27424e47c0c59a67a5217"
    sha256 cellar: :any,                 arm64_sonoma:  "f180790e8b767291efc084d4edf325f75a4c854a7aa27424e47c0c59a67a5217"
    sha256 cellar: :any,                 sonoma:        "394b8bf6a4663a3770ed9bb40df51e4b6f021ef07c9878d0531dbef959312fdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f47b280c6aedf968a9d90df4707ea1729c8108192a1a1a406cf357b76ca016a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "797c2c56eb560352f0b34a3fdb5ab8561be69f8eded8c72f8f024260513368dc"
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
