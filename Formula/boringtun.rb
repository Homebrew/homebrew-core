class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/v0.2.0.tar.gz"
  sha256 "544c72fc482b636e7f6460bfee205adafc55de534067819e4e4914980f0d1350"
  head "https://github.com/cloudflare/boringtun.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e092fc5870f6f58840da66d1e2a00b9768c2ccef9cb8a07d48d9fd3ee3c77160" => :catalina
    sha256 "9d4c270b1a0a5864fc45ebb5fcf0517546cb39b8dbe8ab5d85298fd4b2616090" => :mojave
    sha256 "9c069ca90fed17c4eba1731a1b5bd28b3a0c2736111dc522347d4ff64e48eda6" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/boringtun", "--help"
    assert_match "boringtun " + version.to_s, shell_output("#{bin}/boringtun -V").chomp
    assert_match /failed to start/, shell_output("#{bin}/boringtun utun --log #{testpath}/boringtun.log")
    assert_predicate testpath/"boringtun.log", :exist?
    boringtun_log = File.read(testpath/"boringtun.log")
    assert_match /Success, daemonized/, boringtun_log.split("/n").first
  end
end
