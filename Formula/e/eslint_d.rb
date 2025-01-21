class EslintD < Formula
  desc "Speed up eslint to accelerate your development workflow"
  homepage "https://github.com/mantoni/eslint_d.js"
  url "https://registry.npmjs.org/eslint_d/-/eslint_d-14.3.0.tgz"
  sha256 "f873d33ca7b7851704555a6453798163956a3f525a322d3caea8c16b294933c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f71f81814a0fc35b5b9dc63e435dadc521a5d7fe3c387a9a40327c3d90985a05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f71f81814a0fc35b5b9dc63e435dadc521a5d7fe3c387a9a40327c3d90985a05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f71f81814a0fc35b5b9dc63e435dadc521a5d7fe3c387a9a40327c3d90985a05"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf7a935543ad7d69ad4e8c3e01130765c8c7e4319e749dcbc1fbab0a2d9d8d09"
    sha256 cellar: :any_skip_relocation, ventura:       "bf7a935543ad7d69ad4e8c3e01130765c8c7e4319e749dcbc1fbab0a2d9d8d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f71f81814a0fc35b5b9dc63e435dadc521a5d7fe3c387a9a40327c3d90985a05"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  service do
    run [opt_bin/"eslint_d", "start"]
    keep_alive true
    working_dir var
    log_path var/"log/eslint_d.log"
    error_log_path var/"log/eslint_d.err.log"
  end

  test do
    output = shell_output("#{bin}/eslint_d status")
    assert_match "eslint_d: Not running", output

    assert_match version.to_s, shell_output("#{bin}/eslint_d --version")
  end
end
