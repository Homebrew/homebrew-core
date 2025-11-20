class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "13a09a07177fcf341c963b5e4ea20a52483f471e3ced90b5396ea620bfc1d835"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d770ea67e106e39d7a59769f5af7bc18ef877451437531c108d200fdf9797f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef2c8ef22ce4fffb737dd2acba134857759fad6f9afe3639209563b43ee55019"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9d124964b6a73d49b74ad17d2f6dbc311bb393aac259b6837eefd849cbb999a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f0def3f3867a40cbfcf0b954a76a7a135c09c922318ddd322390ceb88cfad83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1f1e30ef573ccb33aedfba63556f926eeaf70b1ada7c837dcea6b992471aeb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8622a05a0f0703f6c224d85cb78abce9d281b17272b9d2453ff89b2ff9116b4c"
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
    fork do
      exec bin/"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
