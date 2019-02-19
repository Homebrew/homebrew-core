require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.14.1.tgz"
  sha256 "baf2b774138c02750af31e552ea60d9a655da90f9f0645ad0ba435c75d932760"

  bottle do
    cellar :any_skip_relocation
    sha256 "d587a17d48a447ae83d2ba6f043cc3f69ea55c8c05c460234d7cadc302345c20" => :mojave
    sha256 "a77bb1eb37d82955c79c05d939936b056b41f67ef15e53414d4055be573f33a2" => :high_sierra
    sha256 "e95753cb96c26da920bad966c7e9de5975c0ec7af5b3e156fc36501ba4350801" => :sierra
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
