class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/v0.5.0.tar.gz"
  sha256 "a7eaea4ceb6d0b7e4edc97f60557740dfd89288ca73a1ffb985e9fc39fec7f8a"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/boringtun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "999d978e22f5d3c9e9c463b953c4c18e79301823caa671dbac31b9a1fed4fafa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61b268cdfd03dce2ee4c8317a4308d03585fd78a53f5870e922f0f0a83623a04"
    sha256 cellar: :any_skip_relocation, monterey:       "8665ac983c68d9e3145fa945c269c3623c529a7ae12be92757b13605a86234da"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0860db3de9ac7a390e8f0e9a5af305f88863ebdf94bf3bb203bf7f4141a7b34"
    sha256 cellar: :any_skip_relocation, catalina:       "5effcf1f02cb7d66ae871647ab7fa691e4a5e6c3fa049326434d2b9437ea978e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "426ea0dd2ea497e079d2d9f327f8677e2e3dc823a0c0f9563f29e29763081e29"
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
    system "#{bin}/boringtun-cli", "--help"
    assert_match "boringtun #{version}", shell_output("#{bin}/boringtun-cli -V").chomp

    output = shell_output("#{bin}/boringtun-cli utun --log #{testpath}/boringtun.log 2>&1", 1)
    assert_predicate testpath/"boringtun.log", :exist?
    # requires `sudo` to start
    assert_match "BoringTun failed to start", output
  end
end
