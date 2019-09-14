require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.4.0.tgz"
  sha256 "8fa288f0a400269f9128cc037ebf68f516ee7271fdb9435bbe0919bbb4378378"

  bottle do
    cellar :any_skip_relocation
    sha256 "df1bc15ab4914b3536a45ddfce04698cce420269fc6e74ab0e1ae5bfe86eec14" => :mojave
    sha256 "64d36c9e958fcb63283e4c0058d747387585d2b4257ce69d0747ce0a2c943156" => :high_sierra
    sha256 "130652b3e2e9b2272f5233d84a6ea80b0586af818f4d69baac4d60bed3511734" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".eslintrc.json").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")
    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
