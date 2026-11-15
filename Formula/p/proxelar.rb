class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://proxelar.micheletti.io"
  url "https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "09750029dca413b15cbdaf964dc2f888ac41d462c1ec25a90e6f58ea7d7cae72"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4a249eec7031b3e6f787fd01cdb68c07d4bd7a7daf4a7106d11d83005ad820df"
    sha256 cellar: :any, arm64_tahoe:       "f5cc559ff0e1c931d1ade701d40b7e597bbecdf7ba1f0d8d96a7a7976d9a2221"
    sha256 cellar: :any, arm64_sequoia:     "b23a1a9828f41c8a4d9c8fad173d45df43d6c2aca70f995c6832a1ddc12f5cd0"
    sha256 cellar: :any, arm64_linux:       "519f63f95532d4da941cbeabcd315e746576cb6c001973ff879a8e40923e5530"
    sha256 cellar: :any, x86_64_linux:      "556a3b08a1f50c6a8376a3a96bbc79614235c16e9f1c832231306fb3b60ce643"
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
