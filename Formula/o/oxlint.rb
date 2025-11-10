class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.27.0.tgz"
  sha256 "4df286e45eac1fced2bf436dd26af79ae51df0f83e9c71181ad2494519f12e36"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "833d7de1e83ee9a67d0a4be1dec17195fa77051cc72a0adcd1e367c71721c8d8"
    sha256 cellar: :any,                 arm64_sequoia: "cae627d53b6202a9a5df4bbea18e72776f1ff0802ba97953fe12fc5c0d134207"
    sha256 cellar: :any,                 arm64_sonoma:  "cae627d53b6202a9a5df4bbea18e72776f1ff0802ba97953fe12fc5c0d134207"
    sha256 cellar: :any,                 sonoma:        "d05bceb0ac12fbfee0a822bde74a9995d5625823d20108261d33f3cdba3c2403"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ed0d1bbf4ae71881c0ec3c951a9002261d9d69ddda3c7cc96888197f792c927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf7c6064bbf81b6744d2e44595ba6f84194ab0e489c5b4bf056ff7e47a522e27"
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
