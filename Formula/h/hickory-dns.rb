class HickoryDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/hickory-dns/hickory-dns"
  url "https://github.com/hickory-dns/hickory-dns/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "e5158a8e412876768fc3d171ef4b2c3e0d4e99c1a1d082018b93bcda9fb31334"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/hickory-dns/hickory-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "061f24ba1aca3f9a2a68ccec68687654889883c96751a81e0b9085682dbb8043"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a37f168147a5d2db053bf360862c71561d6238203927c4be4f3c92f95b279e2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baa46265ba1dbc8a5445074473fb8bcbd6251318f57a01aa733ca4d1c99e5e77"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e1088d39da8eac4f9c250eee1c8012c3f27b1a83783d66a72b2d3e884a8e546"
    sha256 cellar: :any_skip_relocation, ventura:        "723523e388fe6b2da5b2a263c50aa1e67f3e7d3cb5f4e945c864bf76e62cbb5f"
    sha256 cellar: :any_skip_relocation, monterey:       "e3dbae32c4c47f6d73326a893a295ebf5786aae6e11816b70254b65874e3c818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cc4a411b7a2bd3677c473a8fcd0b47117becb11986409486b9084ae1da94708"
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
