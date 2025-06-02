class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "1baaa7cd72f12a74dfdc012afb682d4b563c005ded80494ac81d43977f4930e1"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5cd57d6aa68183ef6853633d71ea029ed2de6b2cfb75ad2c44be7806a9e63b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73449c07337931a3deedbbc78fde2893375cddd5dcb037a06221cde95df13bef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e63fbb5b094e5a7ff991785df9a644bf80dc5c8d5903bad0a67874cb8c5e344e"
    sha256 cellar: :any_skip_relocation, sonoma:        "22cfadbfad6bba78bb827cb6a2a1f38cc40f502d08f0aac2d7f34b0b4b3058b5"
    sha256 cellar: :any_skip_relocation, ventura:       "fbca68e15b6a4aa447473c2e9ea569d7a4d886fb2ec099bbc8f5e7e177765acc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9383ffb2bed7730921545c06aad5d57954a8b1ae8f1fb95680e179a628ab139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc1802672b3750168d5aa7380d3c7aed552d90eebcd10e6cda3d365bb57775d7"
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
