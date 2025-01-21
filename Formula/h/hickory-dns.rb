class HickoryDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/hickory-dns/hickory-dns"
  url "https://github.com/hickory-dns/hickory-dns/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "72c1d4e4dc16787ebc1bf7565eb5804d4631e473d71bf8ace67aa261e7a6bdf1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/hickory-dns/hickory-dns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2faf2bbeec0a13e367d865d76ea955d212b9ba7828b0d017e97a091caebc5b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a0d671f46052f30576fd724fd8db70184d70b0af03bf58f1672ebfc413294d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "620abe8a9441d5583b0ed4b77cc6b1e285f76a878ce216c91bd10b415d9a9961"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f394c33309a46e308d0a4261f49010af177d2ad4f1a6540d8d5338ec66bf69b"
    sha256 cellar: :any_skip_relocation, ventura:       "32d23b4b68fa67665327bb46f76aba23fa4a92c1cef6092d1fd539d081b01931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ed15fa06da990e9d5b73a876e2ff0119ae86c7a0befc5a5b3cd4d388c0a0508"
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
