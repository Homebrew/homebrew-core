class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "e358d4eb0ba4b01cc0004a23ce6d3bda0201a84e2c21a6a1b9fc3fabc7cda0c6"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1c2804de8e569ccef7c2258f1a0377164c0fb55fe74032d58073c42dc596f95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "889a76fb6091fe6c923a999cc49f66b62b43a7f168d8f93f8798dd27465d5a70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92ea58d688939cb4174980933e6d55220591471e37e50edbdfd5625c63755156"
    sha256 cellar: :any_skip_relocation, sonoma:         "a146e6cd255dbb6478e4fd36202c564c6fe926960bebb0e8bc8f51c29c723d6b"
    sha256 cellar: :any_skip_relocation, ventura:        "38deca31464a812ce82a0ac5c5b78aa7743e02f1fb2a3f369a6cb4e945e2cb58"
    sha256 cellar: :any_skip_relocation, monterey:       "1c9d470607921de3280ac2f348177a0a105934d5a7e41b2426dc2b540c907e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "337d329ad85b36b15522c7555494186f4bc06f4d8164e8b5ef07326326089b37"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Proper test needs password input, so use error message for executable check
    assert_match <<~EOS, shell_output("#{bin}/cotp edit 2>&1", 2)
      error: the following required arguments were not provided:
        --index <INDEX>
    EOS

    assert_match version.to_s, shell_output("#{bin}/cotp --version")
  end
end
