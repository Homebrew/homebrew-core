class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "7fcce48d0aae8f96c94010178a9709afdddc46af902d1965bf5454d83d181fb8"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

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
