class HickoryDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/hickory-dns/hickory-dns"
  url "https://github.com/hickory-dns/hickory-dns/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "53a374acd54ae7eed39802b179f4f542afbcefaa29420dbc9bac7d950e8c3622"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/hickory-dns/hickory-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ad253c2962b91ca323316999d34803b1223254def86587be8f0794a7ab2080e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73821743eb002cb9f4fd6526d229842781dba7d1c5a8a597d600e6f439077f52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96d10898db36cff704103d4364b6928e4bf68afe6c200056ef53ec08483dfb06"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb371131038fa1e825d179d2a29a944f7cd32e07868b95bc78f5d7c6115fce7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a5ca2ce09388c76a77edcd59f258b1fb7d49e33daf09fbf39ccd757f003a756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db41fb4820861917065acfaa4aa95ff0b1880a928406f157de3777e9797d61df"
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
