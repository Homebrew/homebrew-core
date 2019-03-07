require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.15.1.tgz"
  sha256 "480cd5aa1ff1cee1cdfd0e0884f7bdee9480130ff759a384b45f256d6dab1888"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8ca5de86fb775eb15408883f91843bfff7445b9ef59e6fd0b795cc2ce1a9b6d" => :mojave
    sha256 "c39911b019419146b5a0f29676c9b9a2001a806116580b60423da1ed24604481" => :high_sierra
    sha256 "9d3a8c4b289392710f04c5be57c0413530cdf09ed2879b70facd6b8423d553bc" => :sierra
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
