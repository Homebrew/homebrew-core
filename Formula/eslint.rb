require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.4.0.tgz"
  sha256 "597285bfec862ccc80108448fe364b6d9b5ce98ffecdcdfe29d8f907e3a591b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfc5722e476c25133342dcf5dd32db3446f76abf2218b1ecfb9451aa81a130f2" => :catalina
    sha256 "80ad8022413a2283c06d986ec73ba60c1b6fa8cc59735ea8b3a05226922a83e6" => :mojave
    sha256 "f0d2132b186ab9255a67a47fc2c5f6ba116f680210313f5356aea6c3a91827aa" => :high_sierra
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
