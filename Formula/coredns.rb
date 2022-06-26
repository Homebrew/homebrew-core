class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.9.3.tar.gz"
  sha256 "25e607cb39261050513057534b8d2f33bf55aeb18262218bc9396510fa8958d4"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdb8f76795c7e708879903140825480a2254c3e6d0e886e01742431b29db7583"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46a1002d4fabd1351aba5630450f71eb527b9cc0b234c0860586b74a2710304a"
    sha256 cellar: :any_skip_relocation, monterey:       "b4998c03fa6aef0333df12d4e8b8fdbeee3cd9ac7e7e3d275ab89b3887d8e3d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f94c50730bb67a19c9683ca7035d8b5a9d3c0d77f4d377c49281826c8648bd71"
    sha256 cellar: :any_skip_relocation, catalina:       "85d988db163d25c5ebd51696bf0b942b594442605acaff5454be8ab32d460166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6a70eff3a2aefc0fd2a6f4fc83f81f18e694415ea4099b93782159afc16713a"
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
