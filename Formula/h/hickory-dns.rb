class HickoryDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/hickory-dns/hickory-dns"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/hickory-dns/hickory-dns.git", branch: "main"

  stable do
    url "https://github.com/hickory-dns/hickory-dns/archive/refs/tags/v0.24.1.tar.gz"
    sha256 "6659acf5fedb1f3efcfe64242c28898dd18fbd5fbc0cba1ee86185f672ca0b53"

    # rust 1.80 build patch, upstream pr ref, https://github.com/hickory-dns/hickory-dns/pull/2218
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/bdae5218473025d6768eb6ef27bd65149ea2844e/hickory-dns/rust-1.80.patch"
      sha256 "7b201d057b4adf1bc2e916d13ffa7436b86fb7224cd080165f55dcc6e80d64a5"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9cf8eee974c0813048ef68970bfbd33cad00de13d5e242b0a9cbaed625a795e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6efdf02a50da5b06ca7c17e84cfdbb5dfc3a9aa751ce9ef3ca416577ab03bea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5b6c4828dec09e01583940c9816fcd087fb38400235e65a0a3434156e17afa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5476abbdfa937cf8e2547ec9de0a0b5696742d5466a33ae1e31e731e6a5132ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "53ccf15cbc699bd3c12ef3f7db08593a603b22b77ff58c9af4f048f1abd97cdb"
    sha256 cellar: :any_skip_relocation, ventura:        "c10f20649661dbe775b0df4dbcf29a08762e06172b92aa1b2e50a6b58bc6ef21"
    sha256 cellar: :any_skip_relocation, monterey:       "b153715697da34235176eb60f41b53b3e115472c2c94a9cd3ef49b00b62df6c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bad28144b264cb5633d8c321a64c0d0f047ee67a2a09ba0a00ffceeb43733d81"
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
