class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.31.0.tgz"
  sha256 "1b139eb0678939b6ed6ed82d1354d3c263a9954606b962959ef949eb0ee47556"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5652cc1ae38e7e72fc7af24176d51e3e51cb3db707b29038dbb65e8250f0cfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5652cc1ae38e7e72fc7af24176d51e3e51cb3db707b29038dbb65e8250f0cfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5652cc1ae38e7e72fc7af24176d51e3e51cb3db707b29038dbb65e8250f0cfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "7caed69c422aa01d3cecd53ea3f18b6085d6064185e58f74d1810f3629edc8f9"
    sha256 cellar: :any_skip_relocation, ventura:       "7caed69c422aa01d3cecd53ea3f18b6085d6064185e58f74d1810f3629edc8f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5652cc1ae38e7e72fc7af24176d51e3e51cb3db707b29038dbb65e8250f0cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5652cc1ae38e7e72fc7af24176d51e3e51cb3db707b29038dbb65e8250f0cfe"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # https://eslint.org/docs/latest/use/configure/configuration-files#configuration-file
    (testpath/"eslint.config.js").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")

    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
