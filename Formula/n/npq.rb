class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.15.2.tgz"
  sha256 "fa08b543f4d0fe54cc47bd0105447eca6b17eb2b6e1604556804c5b47f9b148c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "39d102ebdbe8640bec223309868779775e911f0ae171916544e3504ba27261c4"
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
