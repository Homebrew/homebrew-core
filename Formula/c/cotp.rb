class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.9.10.tar.gz"
  sha256 "4e7fcaa4ccfc5fa3eb417edeb8b9684ae907caa00603a68497f26aeb4990a594"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbe10265d7c2a58369326434237b74cb907a51d7460c0e7f624c4e94a3168bfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dce26ff09b3b88fd05f5bff8c29e37f56232bcdf253c36e94bc76f9d60394803"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02f5b4469e54bde088fefc896e6cb0dcdb1782874464e3c3aae06cfb472cfd0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "433c40b10664cdc35aed890f20e042bcd07eaf4e6788a9c672ef8857d71eabf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ddeebc8a4a23fe4a55be30d58a8ec98ecdd07576bd5b6321314988830065f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb1ed38de2669322436f1a9b3d9f28c18ecd9105f4683fc04e6ded38c8479f6a"
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
