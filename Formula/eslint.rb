require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.4.0.tgz"
  sha256 "9ae7c52b2974a0bcc8c969f7ed9444058afd0352fd3c6f7772fae9fac50bf6c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "bea5fe7b378bb1be382ddaab09234a82cc5321cb19a078d476fd62e63e17ba4f" => :mojave
    sha256 "a8fa91afbc63e27f0687e0a7dae5ada8b02d1eef03a32752fc4f7f458e9a0951" => :high_sierra
    sha256 "c2e4c24651b34fa120287ddff0682e6c4f1d6d0e64afaf694e40f1160503f6b0" => :sierra
    sha256 "dd3a4d89d1dfe385a4c553e88e928ed4013c6e54f1f73cd034e206605955bf45" => :el_capitan
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
