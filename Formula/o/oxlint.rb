class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.19.0.tgz"
  sha256 "bd25683caaa8694a74a0d2dea7cb848a8c77942bd368370ee258178a54cce8c4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae7cb27d2bc19e6341941677da092c47a6d33827828494bec73c687370cd4112"
    sha256 cellar: :any,                 arm64_sequoia: "2a4fc9623f2281bd547980c52e962f2e60ea14b41987cc9508e030e7192d0869"
    sha256 cellar: :any,                 arm64_sonoma:  "2a4fc9623f2281bd547980c52e962f2e60ea14b41987cc9508e030e7192d0869"
    sha256 cellar: :any,                 sonoma:        "01d1589f7edf63abc1b1bd6ef864a9cfaf95957eaf5c059c3b264899fcaa128c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f82f951b18b4774fb3f66c7b6d48aecb9fbfdc08bd36f479f86ef4a680b60077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bf39eedd8d8d4fb562045087e32f6b79162be073c1fec68c3fb7743623943f3"
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
