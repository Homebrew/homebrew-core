require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.14.1.tgz"
  sha256 "baf2b774138c02750af31e552ea60d9a655da90f9f0645ad0ba435c75d932760"

  bottle do
    cellar :any_skip_relocation
    sha256 "9281ecaf2c9e3594ee930ebde09b2428ac3a15f676ed147bfd97efd393b5bfdc" => :mojave
    sha256 "1c2c44dc415077ca5129c09ce4e33097cae20e300212c23b5e9b148a4fb8dfdf" => :high_sierra
    sha256 "b848fefaa20d18589acbe5f5b75dd9625f4a5d7457983291a239de6702974f93" => :sierra
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
