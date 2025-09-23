class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/refs/tags/boringtun-0.6.0.tar.gz"
  sha256 "3b9fbd7bbc76c5e98237b34b9790656fb38d09cb9ac417361bf5881e44581035"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/boringtun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c63f98c9e4fd4cc7d16792968d183925958bda7ee096f5960eabce10c372b2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b99c028395d91a7117b2287ea874730fa564416df85b646a6a078543a139320a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ce4199d92b31f23dfe37ce587a933fe2d7dba7bf832a4cfab6bd7dda783bb57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47c31d89d533a16220f0f88f23347357f95f7d815e7ceb0773e9ad0423691db2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bc9c266cd64613c37408c3e98ef80eaef53c4461f16c1a3891e361e4cd29c6b"
    sha256 cellar: :any_skip_relocation, ventura:       "0a9e89734c509ad3c0f8dd48d7a8150d0e861ae8120bb8d95ff0b27b44525fb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "210e8a4f5b83d3d7d3ba20fd36651c98bb0025901a51a222412d8a55b89dfe0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8165499bd4051c41df6b5a00dd62b9e5839e5863e54ec9992d7dd83ec400f88"
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
