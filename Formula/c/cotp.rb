class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "f3866e29130078a14ff3da4f544709d1a7a1edb257a77321254a5a87530b6a5e"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4111699df7ffe7374cc97ea2753c3a30f57384c5a0bcd75eb45613e329814ab6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6334353e314ed2be1404c036eda607d03cf900ee29a24867d4ddc9b103cc568e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcac0a74e0f4fd37ea9a2cb5a6e03f41c95c1d9ddd975871a4d0f79402c793ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd915d4c47a2a4bd10d1369cd91bcaeff3aa27bf34f78c4c8790ea9f0e9a849c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "322010d188facd56fe02caaa25cb95ff8d26e5804e849e7d46654f8d9d27c249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "668f4252174abfb367924c0ec518a3766d40206f71f408e698bce1b5e1f9d793"
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
