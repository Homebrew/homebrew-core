require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.15.1.tgz"
  sha256 "480cd5aa1ff1cee1cdfd0e0884f7bdee9480130ff759a384b45f256d6dab1888"

  bottle do
    cellar :any_skip_relocation
    sha256 "124b0ae77179033b014b623918281fd6654ca8594c6918fb366084b4aa6605fb" => :mojave
    sha256 "848f052ad4443372d915dd44915abddb83f5a133f9748589e11a06512155a958" => :high_sierra
    sha256 "31040ea32b51ed7abe25871e98535c4f8b8ca25ae025642530bb1e4ff2dedf34" => :sierra
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
