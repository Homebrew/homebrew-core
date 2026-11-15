class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "3b20d01efec1cf41ae2df59183fe15841495fe22871b7126028abc6c368be4fd"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e0e14ba5ae7c2f87d3b348eb7504d1492d7e7b61b176720b969cf2ac82cc5c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "befcb52ce0812d942de5b755e43194e34ca88463e3dc825465fc8bac8544a5ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ee6312e6d5c412be2b8acfd189f58f0877ab9b311ff471028bd6c529f073c6e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "30aeb352cdaf7627fc4726383e99b283c9045fc979c53443a19fad5ea2526fe8"
    sha256 cellar: :any,                 x86_64_linux:      "3d38fcda6809f576a33239a43a7a61e6c56348414e7c827986b775249b9d8410"
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
