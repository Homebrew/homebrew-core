class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://proxelar.micheletti.io"
  url "https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "ab78c80db38defe15ada81050f9f55c7ca42a824d327a6c75c7a10029216c9a8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "26ae8dfdc568dd2fbeb66f5871c32f3880cf6675ffb5f46c286274443744c6d0"
    sha256 cellar: :any, arm64_tahoe:       "b9e44ffd525468cdf5a55260e2f6694e3d10f683d2540a93eddd11a04a0a328e"
    sha256 cellar: :any, arm64_sequoia:     "d0ba2143e6cbe0ccde7734bd8f87abfbfcfa46947d6e3280db20ad25e5819bc0"
    sha256 cellar: :any, arm64_linux:       "8c81b9aa5b50b280d02c57f682aea4213cda3472d2871d07b6f09a16a94f7517"
    sha256 cellar: :any, x86_64_linux:      "1a82147b17db142994249dd5a21aeb40259c87319ac349ca3fe9e1d30f5eef88"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "lua"
  depends_on "openssl@4"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    features = ["scripting"]
    inreplace "proxyapi/Cargo.toml", "lua54", "lua55" # Allow bindings for the latest Lua version
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "proxelar-cli", features:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxelar --version")

    port = free_port
    pid = spawn bin/"proxelar", "--interface", "terminal", "--port", port.to_s, "--ca-dir", testpath
    sleep 2
    begin
      output = shell_output("curl --silent --max-time 5 --proxy http://127.0.0.1:#{port} http://example.com/")
      assert_match "Example Domain", output
    ensure
      Process.kill("SIGTERM", pid)
      Process.wait(pid)
    end
  end
end
