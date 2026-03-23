class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.9.8.tar.gz"
  sha256 "6b8c42558b2dadaba58dba22eee4618b218bee5186d1bd522367449648740be7"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b012ad1cd7211149460e91d82fe4e1d391ce43533ae7d565b98ef6c4f71f5a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5701112808501ca6225f8b0dd6405caea501e2d172db7e626d395b540d8577a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac9b6e542bad4d6e8a1bea25c0c1b4742028aee462a30bb4ab0849dd5f622b47"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b6d31c7ef56298c759a37cf47bfff5038f43c9654ce9fc42f7616c46f620619"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d731966ac98bf6d7ae76192614403cac15b476cb4c84c662ce5ef1f84547f6b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1abacaea8c6d9e34cc48ace4f834d6adcb12251abbd2304cb39669198470d7"
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
