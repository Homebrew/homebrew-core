class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "3a868e3bbb0794a2f9baee571f43fcded4029ed92ddfeccfa2b4ee54e6e0c927"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72479934ebd72ff1ce24c19f7cc9d764145fb2982fdd08eb2c74e36153d33a14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "909015a4d2655fef31760773898191fdde3dfc8828166a4c1d9efbe830aef8fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ccec62ee3cbd2b30bc45960ec29b237820833566d5a9822dd36df3c9263c25b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3a56d5f358f5a463de07e259c099dd538291a07a98f668290540ac2d1fabec5"
    sha256 cellar: :any_skip_relocation, ventura:        "a9c5789f61a3c8d4f926f0795f17feb8b7122c3d0e26bef7aa409ba80ff24b6a"
    sha256 cellar: :any_skip_relocation, monterey:       "d96620068676206f74a58b5f12422ac7dab68ee0e079ac0664955e9728f2ae1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f963948b0dd3c66c40a82b3047a0e8292398c879b9593758fb4955f9b2b86d4b"
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
