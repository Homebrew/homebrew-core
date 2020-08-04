require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.6.0.tgz"
  sha256 "fd9968727fe5d616cf0d3a361a0c1f13294888ef2ddf9d8beac57d9842dce09e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f180a4ef324728c60b14741466532741315b0b13c23ed5d2b064de16531ee406" => :catalina
    sha256 "a304b697089290fe440c92c3892eb54fd971a5afe4254849dd6763d7379836cd" => :mojave
    sha256 "cefd9d7fd65ca7e02d8f15edf380cc212be6f4802e94adaff1062b85fc106bea" => :high_sierra
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
