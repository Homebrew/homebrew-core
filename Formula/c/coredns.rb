class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "6631fd1d6daccb6eea5a31f31cf8295080aa43c9d0683ff6680b19224c4c2d57"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8e4bd66b79e8f188fb086b8ebf9c3234e5329d993d4b4bf47783be70041bea6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a5019532c93e79477fa9da63d3714ccfe9a9f4ae5b6aba59d4ec15fed2fb9238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e1d55df729ab7b4fd3ecf8ece54f739796e125be0394f6b37e05426fe11a3804"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "11e485391c02ba86174fa3c351bdeba5ca83c91863d48ef1cec442f8d722bb1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3f0c351cf726c40adf15907b69d435b4ec903012fa002455c62dbb9a0b5c3143"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "GOTOOLCHAIN=local"
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
