class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.29.0.tgz"
  sha256 "7db5550a3692d94d98d529f7bd0855898e19593daa3f4550196455b7cd81bf63"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "163e1f17c58bce7937fab5ef5ba0a24d6d804e07c817bd7d0f278d07e1ea0fc8"
    sha256 cellar: :any,                 arm64_sequoia: "6846cbeef27edee8de664d7edf42e903dd02468c3cbadbdc01f4124b8ba58423"
    sha256 cellar: :any,                 arm64_sonoma:  "6846cbeef27edee8de664d7edf42e903dd02468c3cbadbdc01f4124b8ba58423"
    sha256 cellar: :any,                 sonoma:        "a319ab2be158ce2027cde6de7dc974af0fe2c09a1cad0dcb024a037c42099a70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fa0f71a349ab3964be5c4cc4f2db3958028b0e6c5087af6fabf73f7b76f95af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c79df5b249462058850249f0d75fae95afced98197da037646d7094d9d30b528"
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
