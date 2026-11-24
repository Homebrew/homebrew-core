class HickoryDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/hickory-dns/hickory-dns"
  url "https://github.com/hickory-dns/hickory-dns/archive/refs/tags/v0.26.4.tar.gz"
  sha256 "deb0bb4ef15a373b517a235170796e1c876a9d1f4b12a122588b1baf02c00ba5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/hickory-dns/hickory-dns.git", branch: "main"

  bottle do
    manifest_sha256 "6ed4ee3c339c2d10d7c702ba3b25422fc7d8083d0310cd6b58941ac6e66f4f18"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c64924063bc68a9c953567531227eafb58b0b38d43517b104e3ce05e0a49de0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "54deb137b216979aee4ff52a113da72b38476664c6d79e6e412584a06a9bfacb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b8b2fc0e14b7bb547d0d1c26907b5702d1a911081052df7d4609fa80f884a7e"
    sha256 cellar: :any,                 arm64_linux:       "73b934fc77a50fc04910331e6eb45812086f2f336d2bf17d949ea2c94226c900"
    sha256 cellar: :any,                 x86_64_linux:      "e115cfdf86852d49f8e9277383f5120c683c60459949678a3af0c55739a0979a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  # `test do` block runs a local DNS server.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
