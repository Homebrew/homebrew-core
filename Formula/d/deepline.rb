class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.552.tgz"
  sha256 "b822559b49f132a6f4205d353638fa38827553b4c8263edebc5ccfccc7e1c745"
  license "MIT"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "4b812cde487fcde0890d0b4d830064d39b81825876972e651ea1bcc336714d03"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db083b9efe8d4e65081f24ea72e7a89461841182fa25be032aec5953bd7f24d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db083b9efe8d4e65081f24ea72e7a89461841182fa25be032aec5953bd7f24d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db083b9efe8d4e65081f24ea72e7a89461841182fa25be032aec5953bd7f24d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "df5692f76f35c6afa0cea103b1147c7369ae4234e6cc147488845d6ff1d04ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "28cf242a16aa34adee4a2e0919449a7d8b7d983fbacac932f872548d127de41d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder --json")
  end
end
