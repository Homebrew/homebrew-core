require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.6.1.tgz"
  sha256 "eab6da769bcdc0774e2dd89795ca3d3568d8383336ae52ee9594cc1c503d1d91"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ee023c1adb92efa7f8f2fb871054edc52438d02e6e6cec5389abed0df61bc9b" => :mojave
    sha256 "c2c6415ac89b9f4740db79a9f3ebf9b0fcee6fe6face01927e140b281ff063c7" => :high_sierra
    sha256 "31c68f32b29e3c688cedcfa685e50c9806452110d72c7c7d3ddb18106fa6e6e7" => :sierra
    sha256 "0a70be324b639caf331920adc1537a7a286d085bf01dd29280c986dc8164c8d7" => :el_capitan
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
