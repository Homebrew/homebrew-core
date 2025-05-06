class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "d992698e9177f7e9e00031c91d3f4857c39fb6cdc988ee5e1b4424ae6b82ea36"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d234fa403ac86f2df536f76e90ab76fe7bf20134694a10c9c08c59ea0d66b9ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "429548e6194f6950502696a7ab495e47710dadca94fcc215881a69ec7a697712"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8113b265e4caa7e87f07f3086397782e9093eac4f6267765aad25fcb0529ca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b340dc84d3347dfd46305052812c614c6b0a99dcc81b60df2273ad45b36771d"
    sha256 cellar: :any_skip_relocation, ventura:       "0ff8c664232159a53ecb631f8b0dbff67d29f0d6742d412269943e8e29b657e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "507729b15f6dacde3ec96ef758825179cadfde8745ec1f916f01c9b5642edf0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d696e4a80b0a6b10124e8d4004b6da1a06fb7f4143939cadebe4f3ffb077c4f"
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
