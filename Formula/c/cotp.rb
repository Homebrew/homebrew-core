class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "74d4cb39c7c66fd144a400585114e1ba641d5cebb7ba001a56bded5ba71c5933"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab5d8827f38ef8e9c2f541261a0207786c43a06ae680ce53ce93f09728e6b58f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e77fa25e27419685f75442eb4e26e33be461e27f41409a7bea250b93b529a763"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "640b03f9dbd419f697b0ce3a677f5861ce0682d19644b8a55ee75d5701ca34db"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d6573c566aa14215bebe173bafc1cb3773510d5f4be3547f7635579b41d850d"
    sha256 cellar: :any_skip_relocation, ventura:        "3072a10bc06aed9bb27819222921e8bc7356d81659597351f59c13aa4cd608f7"
    sha256 cellar: :any_skip_relocation, monterey:       "00654112359968d0b9c5fd5b5aae6de13d0ed0aa8c8f2f1b58229e99e3d105ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7fcae25e297fec3d2685209df38cbbee69a21e641b850527b4b64b515962ac0"
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
