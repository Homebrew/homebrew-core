class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.0.2.tgz"
  sha256 "cbc072816a6a93aa0512e8af916b9ea6c553f171bf32ae0f8b02fce6762fbb48"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ddcc6bd6f62707a2237e3206b90cc2bb28958e407edef227f4bcae7d0e0ab84"
    sha256 cellar: :any,                 arm64_sonoma:  "8ddcc6bd6f62707a2237e3206b90cc2bb28958e407edef227f4bcae7d0e0ab84"
    sha256 cellar: :any,                 arm64_ventura: "8ddcc6bd6f62707a2237e3206b90cc2bb28958e407edef227f4bcae7d0e0ab84"
    sha256 cellar: :any,                 sonoma:        "d0fe19ebf1d227b733f6a7648ee95b63f1c3aa8ebfbdbbb11b17829b5ffd5ae6"
    sha256 cellar: :any,                 ventura:       "d0fe19ebf1d227b733f6a7648ee95b63f1c3aa8ebfbdbbb11b17829b5ffd5ae6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfe204ea1a6b00d462eaf8d98b7c6c77dbadd6521f390c7408f03f02f7d5d0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea0d94bb206db1541adfe36feec240929be8d6d325476487c2a5abb385626a4c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end
