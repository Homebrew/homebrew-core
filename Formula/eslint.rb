require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-5.12.0.tgz"
  sha256 "adecf09905587e7fbcce6d1b735edb747a7c163de8670081e2764a2248fb2441"

  bottle do
    cellar :any_skip_relocation
    sha256 "e38031b8bf15cd47ad60687455ed687a5657b3fcd6efa67cdcce359f1b28cb08" => :mojave
    sha256 "eb1f1ae11a51f6b639ae2b6bd943108e9f48541a592ac3128c8cb903d0b2b859" => :high_sierra
    sha256 "c3900368443db70e45e67e6c9422aa543bdb39157523096f9488da8a416dad7b" => :sierra
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
