class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.24.0.tgz"
  sha256 "086cb015b03e596d55f37e5a161362449bdde510ee0882017720c1660be49ccb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "150ed713ddbe08984f2aa4796585e54d95a8f2f09cfb2d34b11204c81b0e7cb2"
    sha256 cellar: :any,                 arm64_sequoia: "74a6fc57cedc621170dd71cef8e675592ec21284075b378c74c91459270aa845"
    sha256 cellar: :any,                 arm64_sonoma:  "74a6fc57cedc621170dd71cef8e675592ec21284075b378c74c91459270aa845"
    sha256 cellar: :any,                 sonoma:        "619883d70cfc079cb4e08467c7fe71fe5c29a7f0725e8a7a22743de61aace15b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b819b35851ed431b7e51649a2ee56d00762732ab8713099060269b4592f3649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3018ef6a093daaef69130e1faf7fde17603adfd53cf131b64748d91d6172fbe0"
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
