require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.18.0.tgz"
  sha256 "69ef2a30f22c4157930ce54a7c8141e2e5596bdc4a13a4d7c43e0e6023566984"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cc7a047c7316c89c32b50a5a1199862519fc82bda820099a20cfd84b3f06eb75" => :big_sur
    sha256 "15645b1558abdbede3dd3af535212e98aef62b2b203a1ba2856b522837b9ec89" => :arm64_big_sur
    sha256 "0711399a4f2b1ab5bfd9c664933a7165cbeaee1a3df0ba9942b97194a53c5583" => :catalina
    sha256 "3730c10c47dfa12720a90cbd668e008c8f1325d3a62f234fba0d0d2f8c6f6f7c" => :mojave
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
