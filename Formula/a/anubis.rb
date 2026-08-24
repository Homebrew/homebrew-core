class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "5a3f93d5b763283e2432f2574f30d30434befd5e1788990bd031bdf0696e78b3"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cd6295e24a4155cd4f0798f9b35350600511d8e1987600852e292bc4b02357d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eacc20672b0cb83bd1a4b9fb34c390219267cd25180d1e50489463b21edcfbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24f89dd774abe9a05d165249c21320643ecf1df76cd679000fe809bf718aca24"
    sha256 cellar: :any_skip_relocation, sonoma:        "35afb4c7f9ee12a87b59b74b6f3ffcf51a8542f28d391b1021110ea7a5bcbc29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9f395f3b3f990756b5de7910c5e33dbffc1eb2c8fcf2b819cfbeb9bcd3e5a62"
    sha256 cellar: :any,                 x86_64_linux:  "aef8bf549b530849bc3a795d075125b2eab7f5159824f32321a2d53eda83c613"
  end

  depends_on "brotli" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "zstd" => :build
  depends_on "webify" => :test

  on_macos do
    depends_on "bash" => :build # error: shopt: globstar: invalid shell option name on macos
  end

  def install
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
