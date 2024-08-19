class HickoryDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/hickory-dns/hickory-dns"
  url "https://github.com/hickory-dns/hickory-dns/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "6659acf5fedb1f3efcfe64242c28898dd18fbd5fbc0cba1ee86185f672ca0b53"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/hickory-dns/hickory-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e04f049202dc1cdd4669de909a9661cef5d00a157a72369936cbe1a36cd5afc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc08149f341cac341c7b3b8ed0633f895acebacccd52c1cf579527c000189424"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7c04e7743c1e062687b1a568fcf8966db4b862a4fc973ea030b785d2c1c019a"
    sha256 cellar: :any_skip_relocation, sonoma:         "266c7188d78e19e0d8ddbd076db5f4c16efeffa3d36a0577e548b9b4b6c911b4"
    sha256 cellar: :any_skip_relocation, ventura:        "6081fc1e6280c37639a60cb970ffbc70c7657b8a589ec96dd44490d7d4260183"
    sha256 cellar: :any_skip_relocation, monterey:       "4e51d22107ae996030f1bb38fd78d4b250f3929b3bae5dd27882f8376c8b892f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7ecaab8544acf9c891c5a4431efa1799963c3935888aec29157a8d7b959f423"
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
