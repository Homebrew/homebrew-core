require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.16.0.tgz"
  sha256 "98aa265e3dd961425ba200d05e50244be333548cd5cb9a98116869cdd36c6467"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dff15aa679bba67e05b8afd8dcc91a91575537d420aa10b7d8d88fb1309b6e7b" => :big_sur
    sha256 "f3b3d88769da39e713f7da58129120107221a2bd6d21d1e2951f443b8d269781" => :catalina
    sha256 "468091e30bebaa6f2a392a114a45c4ee58bd4b2fbdfca6d1ee7ad4fdb11d6059" => :mojave
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
