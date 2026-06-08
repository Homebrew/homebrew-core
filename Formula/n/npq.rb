class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.19.6.tgz"
  sha256 "50785fba38ba4ca79fad76ffe90bcfe88dd67558d7b7baedb9477cece24a4382"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c7722a8e1aee9d62764305060c83544b09273caf68755bab4ef0c05752d4d26"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq@3.5.3 --dry-run", 1)
    assert_match "Package Health - Detected an old package", output
  end
end
