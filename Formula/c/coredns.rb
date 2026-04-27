class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "137a5da5f49c8eb81e2cc3929d462606146faaa651bd609031d867eb6c73748f"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22ef9f19ec4fd03b11d7325eca93384ef692c1d74e9df095c50c3eaf91b0fa02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0743fe1bf7709cfbdd53ff4e9885edf654a07401c794eb0d894805e00aa9f254"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8335119eeb51c8e3ee14e397d5cf0032dd0af3a672d2fe6b68ef5bce11b8b40"
    sha256 cellar: :any_skip_relocation, sonoma:        "527cdf0e757e0c393d7b1b27ffc3b34150193fac57829c68f7d79931fc656d9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3e52ef41b4a080ae1d68935e5e16193f124798832cbb941a7c5fd4357d768fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6821499c09a53b3607c904d1affeea60de630da413d6d952d70f21f7e6c6385"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  service do
    run [opt_bin/"coredns", "-conf", etc/"coredns/Corefile"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/coredns.log"
    error_log_path var/"log/coredns.log"
  end

  test do
    port = free_port
    spawn bin/"coredns", "-dns.port=#{port}"
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
