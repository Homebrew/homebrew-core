class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.24.0.tgz"
  sha256 "086cb015b03e596d55f37e5a161362449bdde510ee0882017720c1660be49ccb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5bce182a185fd8776d9255a371502adcbd11f41362e74daa1a3807963bd1c259"
    sha256 cellar: :any,                 arm64_sequoia: "febe567c43fecf6cec8529e26515f0a789181a4d1fd9ae48f9a90195962a86dd"
    sha256 cellar: :any,                 arm64_sonoma:  "febe567c43fecf6cec8529e26515f0a789181a4d1fd9ae48f9a90195962a86dd"
    sha256 cellar: :any,                 sonoma:        "eb9ca6f01fbfb34374bf17d6bfdc2dfe8dfb8ea90b204115167935489cfc9b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02258114ec0d4e9425d2166ddcb4ea3aec5b7725644160a5dcce7406e83b4fc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "849fbf5fa6e41ca1de32ad664ce5892c6280575efae7aa41ce0148f61ea6a8f9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
