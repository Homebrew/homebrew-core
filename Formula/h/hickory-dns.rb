class HickoryDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/hickory-dns/hickory-dns"
  url "https://github.com/hickory-dns/hickory-dns/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "4d623c78cd9e098b1d00a17b0fae3e6dbd192b886e07b2324060dd5349031a39"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/hickory-dns/hickory-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a33f3f789166703dcc05376fb8616eef4be0c34f36bee6b1ae10c914cb6fb78b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "421b6af839f3872e2b3f13d6d3e49c52d744099cf9bda59b4b98d0214b5c26b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af16e713fe41772f591af1f17c4a47e19b4e0777248f422cc35f8c9155e4bdaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5fa9d0779ab05a7a787d305a079fc57b882f205ac42eaf2d046da66dd62a80a1"
    sha256 cellar: :any,                 arm64_linux:       "c58cde955439c5ea965aa523d417314c84d806c7537b9f42aa47fee6bfc48866"
    sha256 cellar: :any,                 x86_64_linux:      "48eddfc4a2730a30ec2eb6ce2532731844c3a86db05cefa8b24fa085434f89df"
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
