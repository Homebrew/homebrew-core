class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/refs/tags/boringtun-0.7.1.tar.gz"
  sha256 "734e2c542efca8a76fd75ce6db1afd75593e1e3893a94c3973096060f1168465"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/boringtun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59432e2c236ddb04d319d846997dfdeb62ca909dc397e7e012036d52070c413e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3556b91162eb1ead779e4e595374a49e8c3c9b4681d4778be04cf09c06bfc0ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e8b1e9bdad4465d5736ff85a7a2e50be9cd67d71c9c32b94f29801f2e1653ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d596ead2f6adc48d6ec310e0db784113f9d5db3c830b6a2a976479fa3ffe096"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5118bac42ee0b4cc447d14e80879c8ab13361cbb373b7b97cfb36b0891408da0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "392c3c6b31d97d83e954483b6b7a92af52c927023c369fe43f3430eef5add48e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "boringtun-cli")
  end

  def caveats
    <<~EOS
      boringtun-cli requires root privileges so you will need to run `sudo boringtun-cli utun`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    system bin/"boringtun-cli", "--help"
    assert_match "boringtun #{version}", shell_output("#{bin}/boringtun-cli -V")

    output = shell_output("#{bin}/boringtun-cli utun --foreground 2>&1", 1)
    # requires `sudo` to start
    assert_match "Failed to initialize tunnel", output
  end
end
