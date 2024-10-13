class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.1.8.tgz"
  sha256 "f2404d1e5596ee7a6af9906bdd1b6365423ec16e75f55737336870be2a41b0b0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ba6688a79382d26e0c7f4028994f65960cd345048cd4c437ac1283f0dd54ed3f"
    sha256 cellar: :any,                 arm64_sonoma:   "c3d8dfa0f3fe17d6cc0a1249376aa5746e5bb5e80c3e24c08fdb7d6cd6cc012d"
    sha256 cellar: :any,                 arm64_ventura:  "c3d8dfa0f3fe17d6cc0a1249376aa5746e5bb5e80c3e24c08fdb7d6cd6cc012d"
    sha256 cellar: :any,                 arm64_monterey: "c3d8dfa0f3fe17d6cc0a1249376aa5746e5bb5e80c3e24c08fdb7d6cd6cc012d"
    sha256 cellar: :any,                 sonoma:         "53eb46ccaa58156d095cef438f907dca9a2de1d5ae4b424dd3bc1179fa3d75e1"
    sha256 cellar: :any,                 ventura:        "53eb46ccaa58156d095cef438f907dca9a2de1d5ae4b424dd3bc1179fa3d75e1"
    sha256 cellar: :any,                 monterey:       "53eb46ccaa58156d095cef438f907dca9a2de1d5ae4b424dd3bc1179fa3d75e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38b853ee6dc578484b09d9c6e67bcac94a6625b23ef79d125e02e4671e445cdc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
