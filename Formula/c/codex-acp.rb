class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "08765b8cfbc9218fc7192348065da22820657dba040f31119de13ba6a20be7e2"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df2b45deb6d78341b196a8ee4085d85c33f47e18adde859ba17d142584ff8b18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07298359e6b33af582e3d464db5a23a01928a25b66215ee25ece19c85019a1bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fde82fd314bdeea7110005ddf864668948b1ce9adb93645053b84483c8cfe3b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8554790778f55fff91b2297d772d337da2f6f0e7fc66f6870401602b85164fd9"
    sha256 cellar: :any,                 arm64_linux:   "33048793ab006d7ca43f12dae3ac306380d50392ffc2c4cbff8c23c243f2e451"
    sha256 cellar: :any,                 x86_64_linux:  "ea5f8f4915a88f34b11f2c286eaa6267d0a23d0e1354dbb42450a4ee110b9442"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "libcap" => :build
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"
    require "timeout"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"codex-acp") do |stdin, stdout, _stderr, wait_thr|
      stdin.write(json)
      stdin.close

      line = Timeout.timeout(15) { stdout.gets }
      assert_match "\"protocolVersion\":1", line
    ensure
      if wait_thr&.alive?
        begin
          Process.kill("TERM", wait_thr.pid)
        rescue Errno::ESRCH
          # Process already exited between alive? check and kill.
        end
      end
    end
  end
end
