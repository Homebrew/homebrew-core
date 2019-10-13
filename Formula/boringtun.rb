class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/v0.2.0.tar.gz"
  sha256 "544c72fc482b636e7f6460bfee205adafc55de534067819e4e4914980f0d1350"
  head "https://github.com/cloudflare/boringtun.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "96ba513a56d965a3eb6040ccc011f8163b58a94ebfa012222886fe06881d50fa" => :catalina
    sha256 "54e373b9f76fc6988ed21454e567e038c835539241ee6a43f7c5d31ce90226e2" => :mojave
    sha256 "141f4c394dce33a0559debdd2b5c89fa4064117953a414cb07ad426b4b24ad97" => :high_sierra
    sha256 "54172a4b63ed22ae431d7d018a1d99da5dfe80637d879c9647b93d9c976186c1" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
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
