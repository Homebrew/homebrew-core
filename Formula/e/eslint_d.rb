class EslintD < Formula
  desc "Speed up eslint to accelerate your development workflow"
  homepage "https://github.com/mantoni/eslint_d.js"
  url "https://registry.npmjs.org/eslint_d/-/eslint_d-15.1.1.tgz"
  sha256 "41e3aa6e49daa1659e09565870160bd1b30bc63e63bb2c167c7ce06799245fcf"
  license "MIT"

  bottle do
    manifest_sha256 "73c4aa28b0a09f554ca3f1e0b7b209159adee97652e42ad6adea607ce8132489"
    sha256 cellar: :any_skip_relocation, all: "881d6c16fd1e0bc01fe289957491ca752331a20f795ae09b9508a5fca8f4eec8"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
