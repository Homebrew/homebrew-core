class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.13.4.tgz"
  sha256 "31c0a2ca74951b558c1375430f7c509ea3ef8083e8f05aa196a8b58a2ea58624"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c55572ddab40d3449400239dd83b1d825752564cfbb5c14a3bb2a0f9e19188fb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq --dry-run")
    assert_match "Packages with issues found", output
  end
end
