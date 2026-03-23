class EslintD < Formula
  desc "Speed up eslint to accelerate your development workflow"
  homepage "https://github.com/mantoni/eslint_d.js"
  url "https://registry.npmjs.org/eslint_d/-/eslint_d-15.0.2.tgz"
  sha256 "b329300563f43d3bc3ed8b58e7341c85d670f806a719182a029e308966a1c6e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "de4a449370367f71334ac97392914b3d6c5b3ffae46b323a2f889dbd1ede44ba"
  end

  depends_on "node"

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
