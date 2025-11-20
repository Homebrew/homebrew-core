class Nrm < Formula
  desc "NPM registry manager, fast switch between different registries"
  homepage "https://github.com/Pana/nrm"
  url "https://registry.npmjs.org/nrm/-/nrm-2.1.0.tgz"
  sha256 "cdad289ac8e72878ab72575ee61551b5d1cb6334097d6904f5ce30603ae5c74f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fe1e778553efe4a3562c5a800617a7c112c075961c42f1d7b0cd84f7884c5aa7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "SUCCESS", shell_output("#{bin}/nrm add test http://localhost")
    assert_match "test --------- http://localhost/", shell_output("#{bin}/nrm ls")
    assert_match "SUCCESS", shell_output("#{bin}/nrm del test")
  end
end
