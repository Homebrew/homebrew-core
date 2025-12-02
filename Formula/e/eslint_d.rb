class EslintD < Formula
  desc "Speed up eslint to accelerate your development workflow"
  homepage "https://github.com/mantoni/eslint_d.js"
  url "https://registry.npmjs.org/eslint_d/-/eslint_d-14.3.0.tgz"
  sha256 "f873d33ca7b7851704555a6453798163956a3f525a322d3caea8c16b294933c3"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "178cd948fa99952a64664f10233c8d38e66760683a98e8322fdc2963f97e3b98"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  service do
    run [opt_bin/"eslint_d", "start"]
    keep_alive true
    working_dir var/"eslint_d"
    log_path var/"log/eslint_d.log"
    error_log_path var/"log/eslint_d.err.log"
  end

  test do
    output = shell_output("#{bin}/eslint_d status")
    assert_match "eslint_d: Not running", output

    assert_match version.to_s, shell_output("#{bin}/eslint_d --version")
  end
end
