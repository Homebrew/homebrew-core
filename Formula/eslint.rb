require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.13.0.tgz"
  sha256 "188940e431dbb32db7797be55f442349c990318ed7940849e49c1c4d2ec75b77"

  bottle do
    cellar :any_skip_relocation
    sha256 "041f885262859ebd6c49270e700619c58acf062ec9c76ab353b23cebc2e4b2aa" => :mojave
    sha256 "493cb14ede50f54bea0e73767e091b40673a175fb0e9e32e76b768a29bc9973b" => :high_sierra
    sha256 "6ddf629a67dffcb1b625c003197193b113ad50913a662587d4c700d74151ef37" => :sierra
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
