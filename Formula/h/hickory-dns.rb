class HickoryDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/hickory-dns/hickory-dns"
  url "https://github.com/hickory-dns/hickory-dns/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "ba79d44071511b4989da1f13f4369b0616b90266d4ecb60b657650275edb989c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/hickory-dns/hickory-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afbcef9a524f31b8453e977c36a7c9d42067fbf3af58a15cca77af81995f6952"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d8900b72c0cd8681b01174bdf2913b18f02a9d894aab0c3ae6124bbe3a66f87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22c0863f59f89b04528a5ce73d376b39e1f48939d9c658c56c6e2e32b8d926db"
    sha256 cellar: :any_skip_relocation, sonoma:        "7af2d32f518c5a2371c019c7a17a663e368fbfa55d0b9806bf5f9d4c2243591c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9c735f43a2a050d7b9360ad93fa267e489a960546de383f884afdf047ca0001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf04ede797638711d88d0830e007e873f3af1a731952cb70d71cc273be21f4d1"
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
