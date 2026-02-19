class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "6234805a8eb20a71d2acb07ad8d7827bd5c98c653b7eb733bab0f90cbb9f6212"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e40cfa0d477e95401ba5ab31c28936fb21ee4161487332139359b16aee9a7e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f105e5170e4dfd99ac9c5705cfec4da962dd9d042c65391850ef52bf2188acb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0d63eadd60c67e5ea688de26b2c2a593920df9912aee283b956e5de75070e8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1af2f1c6dcccbc35ffd95afeec227c814d5d2c93f2ede99e39c40c2720473128"
    sha256 cellar: :any_skip_relocation, sonoma:        "66ffb02a6f5d8a79f14f4600ca48689e8dee207b0d9a8cde8dd38a6d4df7b8f6"
    sha256 cellar: :any_skip_relocation, ventura:       "7cd768133c3bfdbd0ea5fb6be8d5b1180054e80df9f22ddb3cd4469c314fc211"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1a5443da0a3e40a0bf4eeaa1628856e1450941b2525b8d11718f1cd015853b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1db73eb628d909682aa79db0465904835d5ca56e52f372f196e3c1c23d9837a"
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
