class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.31.0.tgz"
  sha256 "70b9e0440704bb95b9a3a98874b4564fc053c6c4ecaa6e3de1bc64d79df20093"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a8a778fda65609c1f8de1212094f77cceadb45a9db25051ba3837f64661be638"
    sha256 cellar: :any,                 arm64_sequoia: "bc439da33a60b82f3c612accdecceb440f62214d3936c5354de2612e98810bc9"
    sha256 cellar: :any,                 arm64_sonoma:  "bc439da33a60b82f3c612accdecceb440f62214d3936c5354de2612e98810bc9"
    sha256 cellar: :any,                 sonoma:        "dcbd5de8972d7e23c60b4485ddd2339a93ca186c974c6524f190f97a950ef6d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "160319ee68513a49af2acf307c649e7706bea508d04b51e9673f83ad306da76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "906a18eb14ce92b91b2c74c4d121a4da362bf75b713289c31dc2fe7728879659"
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
