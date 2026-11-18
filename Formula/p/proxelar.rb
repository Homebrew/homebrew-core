class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://proxelar.micheletti.io"
  url "https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "6570666545c10cdd954c2b39961087c825ffc54c8bbbe794cad1b012f4629c36"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "db81050f106a659d15ae5e4ff8f2fbf21b102c41481218af32661a29914950ce"
    sha256 cellar: :any, arm64_tahoe:       "c2b9c45f3e0b465aa2018234ddd61b11e48a7939fc13ec026a5df350b8f801c0"
    sha256 cellar: :any, arm64_sequoia:     "cf9e1f182059f281bbe3c3dd482c642e5dd982c561a85a1d3f6dc66641f5ea6b"
    sha256 cellar: :any, arm64_linux:       "b241d95701ebe92333a154b6f7af0bd3ccd23cf1cce442727820a1d23a3632ae"
    sha256 cellar: :any, x86_64_linux:      "cc40876bdd56b3aed7f6dde5a7caa6b1e82ea6980ede3b4ca8aa4aadf2c66a90"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "lua"
  depends_on "openssl@4"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix
    features = ["scripting"]
    inreplace "proxyapi/Cargo.toml", "lua54", "lua55" # Allow bindings for the latest Lua version
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "proxelar-cli", features:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxelar --version")

    port = free_port
    with_test_process(bin/"proxelar", "--interface", "terminal", "--port", port.to_s, "--ca-dir", testpath) do
      sleep 2
      output = shell_output("curl --silent --max-time 5 --proxy http://127.0.0.1:#{port} http://example.com/")
      assert_match "Example Domain", output
    end
  end
end
