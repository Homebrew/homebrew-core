class Boringtun < Formula
  desc "Userspace WireGuard implementation in Rust"
  homepage "https://github.com/cloudflare/boringtun"
  url "https://github.com/cloudflare/boringtun/archive/v0.3.0.tar.gz"
  sha256 "1107b0170a33769db36876334261924edc71dfc1eb00f9b464c7d2ad6d5743d3"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/boringtun.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "97dc60eaf03ff668094d700af5ef656c7033e0fe6b6e7cacf287ebaddf8c5b46"
    sha256 cellar: :any_skip_relocation, big_sur:      "0de06cdb03839450dbe101b3f1042820f82aee7eda323039be0f48a0b2baf3e9"
    sha256 cellar: :any_skip_relocation, catalina:     "dd119327645c4905c39a4b0e6f65472690d619e127088e62573b5a0c454cbb01"
    sha256 cellar: :any_skip_relocation, mojave:       "c871b547c950e928ee065ce5dbe1442a41d65213b840654bb9e6922b7dedae0f"
    sha256 cellar: :any_skip_relocation, high_sierra:  "7e6fc1a3b6458d9df1b0c15ee53d14f0ea04e85494f306034fd8531d2ff4277c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d7b49eed536d9c38b5f0c56a8ef447aac785af786f386d1510fb04bd7d894afe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/boringtun", "--help"
    assert_match "boringtun " + version.to_s, shell_output("#{bin}/boringtun -V").chomp
    shell_output("#{bin}/boringtun utun -v --log #{testpath}/boringtun.log", 1)
    assert_predicate testpath/"boringtun.log", :exist?
    boringtun_log = File.read(testpath/"boringtun.log")
    assert_match "Success, daemonized", boringtun_log.split("/n").first
  end
end
