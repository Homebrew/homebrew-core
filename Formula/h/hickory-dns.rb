class HickoryDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/hickory-dns/hickory-dns"
  url "https://github.com/hickory-dns/hickory-dns/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "b4f4b3ff1cbefd1023c6e2b96b3db237e051e4b6c3596cafb310da4901212e58"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/hickory-dns/hickory-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00338c97c57b343444b4d6383b5f4537a74ce7eefe7267699773bf176697121a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8f589615fd4ae0e19b330aebf7c932480fd246e2e890e263cb091c9deb3229c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4641077055a67a0cf03f1a91f7b08e3ce543fd357b546fa23ecac969117eaec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "898885c68864696ba13319a1d7d5b079d6e2c3dc535cce904d0d1b95d24f3cbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "93208fe97224110bb8ff4638f3ee46936701f6a25d219e8b85a0b08224aaa343"
    sha256 cellar: :any_skip_relocation, ventura:       "382b24e7db321eca7f60bd4c0b35994413ff9022e42b9d685a4fe63def240cbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cffb447b25434f6d148933f632a8445b5dfbcaf5208f195707b21348be3ad0ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5a06249c3bc754dac00f8f5924b864dd2658476c309d82c38a82b6ddefee282"
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

    pid = fork do
      exec bin/"hickory-dns", "-c", example_config, "-z", test_config_path, "-p", test_port.to_s
    end
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
