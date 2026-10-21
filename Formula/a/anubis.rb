class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "f7de156f566ad3381b6170a8e581e9026656d63407cee7a412474c4a9e8546cf"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6909231b1b49c8183c09213d758c58169d02797b28d02e0ca7fef18a468bcd9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61320f48a8e186446868cc1f3fdfb7a342a6584ef0c7ab0c6c2bd4bb9c8b34f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ecb8f541f09cbc18a6a94f647672781deaf1a0a8c2bacaaa1606c5f162e45a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "732e2aef1e395d127882ba3c169ae055e3b4a47adb67da659b2364b6ec9eaf13"
    sha256 cellar: :any,                 x86_64_linux:      "1ad271b1c4335599fb4c52ca85f44eda1270eb0ebf486b2921e56e1f2919981a"
  end

  depends_on "brotli" => :build
  depends_on "go" => :build
  depends_on "lld" => :build # for `wasm-ld`
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "rust-wasm" => :build
  depends_on "zstd" => :build
  depends_on "webify" => :test

  on_macos do
    depends_on "bash" => :build # error: shopt: globstar: invalid shell option name on macos
  end

  allow_network_access! :test

  def fetch
    system "make", "deps"
  end

  def install
    ENV["CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER"] = "wasm-ld"
    ENV.append_to_rustflags "--sysroot #{HOMEBREW_PREFIX}"

    system "make", "assets"
    ldflags = "-X github.com/TecharoHQ/anubis.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/anubis"
  end

  test do
    webify_port = free_port
    anubis_port = free_port

    webify_pid = spawn formula_opt_bin("webify")/"webify", "-addr", ":#{webify_port}", "echo", "Homebrew"
    anubis_pid = spawn bin/"anubis", "-bind", ":#{anubis_port}", "-target", "http://localhost:#{webify_port}",
      "-serve-robots-txt", "-use-remote-address", "127.0.0.1"

    assert_includes shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{anubis_port}"),
      "Homebrew"

    expected_robots_txt = <<~EOS
      User-agent: *
      Disallow: /
    EOS
    assert_includes shell_output("curl --silent http://localhost:#{anubis_port}/robots.txt"),
      expected_robots_txt.strip
  ensure
    Process.kill "TERM", anubis_pid
    Process.kill "TERM", webify_pid
    Process.wait anubis_pid
    Process.wait webify_pid
  end
end
