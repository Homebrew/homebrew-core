class HickoryDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/hickory-dns/hickory-dns"
  url "https://github.com/hickory-dns/hickory-dns/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "22feb683f4eae7f96901f141f88c0e06969504c238482798d1a91231f0ae13bb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/hickory-dns/hickory-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8892dffd2f7707de14ca857a1cb84714651a6dca2b41dbe7855b973c9a6fc36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de53afa80f9b795cde441e04e319a14f1658fec6c841d149017b30527e4eee7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2a45494677136cd63a73b3caa4991f0d055080629ff8445e2f0184e529c3a3e"
    sha256 cellar: :any,                 arm64_linux:   "cdc293e43392a5ead946194f691709cf1dd5da025ebfd2d4f400495f5d127ffc"
    sha256 cellar: :any,                 x86_64_linux:  "ed8a0889eb5be0672746eefb6097e3942a601aac6b5ca048fe5e438ea481ae17"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "bin")
    pkgshare.install "tests/test-data"
  end

  test do
    test_port = free_port
    cp_r pkgshare/"test-data", testpath
    test_config_path = testpath/"test-data/test_configs"
    example_config = test_config_path/"example.toml"

    pid = spawn bin/"hickory-dns", "-c", example_config, "-z", test_config_path, "-p", test_port.to_s
    sleep 2
    output = shell_output("dig @127.0.0.1 -p #{test_port} www.example.com")
    expected = "www.example.com.	86400	IN	A	127.0.0.1"
    assert_match expected, output

    assert_match "Hickory DNS named server #{version}", shell_output("#{bin}/hickory-dns --version")
  ensure
    Process.kill "SIGTERM", pid
    Process.wait pid
  end
end
