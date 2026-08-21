class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "9194f1cb838783fe5c4d27651d836364c04adca126ea67808574ccdf064413a6"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12bfbbe7c25d0d9e37605a0968d6357c9d4eb13e4577efaffbbf40b54dfe13cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b74821e2e7fe50aa44e9850dc76dd71ff95e2e8a863d7ee1994197bd6428634"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69324a3d122b7ec785d35cc1ebcc8d00ad2ee23145e697627df17d054421a77a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8144ec19e58ab30adb8fe654da99f68ecdde4d1207686fb664b613d6cc7a9cc3"
    sha256 cellar: :any,                 arm64_linux:   "75cbaf9812b81f7ef9d13697f5997b0fe910e55c0a31e8ead594eaf87ecc5430"
    sha256 cellar: :any,                 x86_64_linux:  "159db74c67cc9051aac7935e4fbba0989f04f4f0dee464c000e5b29b4f99e565"
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
