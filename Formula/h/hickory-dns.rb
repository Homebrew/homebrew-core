class HickoryDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/hickory-dns/hickory-dns"
  url "https://github.com/hickory-dns/hickory-dns/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "40d3cf656e6c1e232d3a9c6234ecd2a1762e7fb7b2cb1e47956f80ca980d4842"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/hickory-dns/hickory-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f46ab22f79ed2e549e981406035a34cecdb849050b53b9d2c200c1d3a0f39c04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "010d8552c0e332a1cb9b869bf4bc9dcab3d23faeb7e24cf3d97146a77ce1d63b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82bbaa6d138064a9c65c06b4bdc5ad3ed402120eaaa25d0058d2a11d9d6d4ce5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c7e58efaf46ddc675103dcf4cc0fdf48b79effd865932be537ecfa0ba901b5e"
    sha256 cellar: :any_skip_relocation, ventura:       "b639f804ea3585b82dd21c6c4c0b8811d30abc13da7889936759c2f62f5a6bbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bfec86cd4a461c2e61390b40cc050d5a2fdb2ec622f70e30f13e23bc35c429c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a809089a35c45c529fd83f475be42f67ebd9f267fbf091527b50df92df3cc288"
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
