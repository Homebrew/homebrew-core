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
    sha256 "3cb095b7227095ba6634e2c6676c00e27d177256ed1505261b0e65b9a5fa8070" => :big_sur
    sha256 "8df81df3517a13fb7a883735941a14a97ea54e9275f8036603e155469ab53274" => :arm64_big_sur
    sha256 "06db70e58f329c89819f783b88188a93443275bda67815ec738aff933e0248c0" => :catalina
    sha256 "0fb33b1b90039e994766517ce4a86d475f9776d118119806168dfd683e9b6204" => :mojave
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
