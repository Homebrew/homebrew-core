require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.2.1.tgz"
  sha256 "9513703f9fc2ee9015817feb3e847734ede19e2c3aa1fd67cea3188e21af7432"

  bottle do
    cellar :any_skip_relocation
    sha256 "62fc8567b228e4165ef176cc66efbc41831da3296c127acb941f6e800fdd13ab" => :mojave
    sha256 "b72c769d06a40a50aa5754ca317a0e879145a446a82686a32fa5ed2fe6ef347c" => :high_sierra
    sha256 "e30ca28650d2faa0a65b7a95032affea7f4c4ebe84c0cfc2768b0a492304808f" => :sierra
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
