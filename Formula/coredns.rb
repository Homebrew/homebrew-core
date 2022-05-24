class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.9.2.tar.gz"
  sha256 "254e38989f86fbe937b80d84ebfd3aa45485013e4fb1604bffd485a7d022e13b"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "178779d7b41cae16b5f4ac2718ccd087cccf473a1a2778332e70e27d89456c41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5511b74e0f95bd3bccce3e997d54e161a303e6f42385c787932331a6281a7056"
    sha256 cellar: :any_skip_relocation, monterey:       "fa5339eac86103693f332b479c4e5d1c64c685fb0bad7a958376ef20481e16da"
    sha256 cellar: :any_skip_relocation, big_sur:        "694219c43beddb974d53b26a762a92045f89fa3f0573e8daf19bcc81014dcfca"
    sha256 cellar: :any_skip_relocation, catalina:       "01e0579e50bb4d9bf722f43bd06245f184251d0dd88a4a0ebf92decc030d5439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ee3bd81e907818faeebbcfb34df3a20fcd5a58c8ec13a734e4a200b17fed597"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  plist_options startup: true

  service do
    run [opt_bin/"coredns", "-conf", etc/"coredns/Corefile"]
    keep_alive true
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
