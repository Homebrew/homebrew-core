class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.11.1.tar.gz"
  sha256 "4e1cde1759d1705baa9375127eb405cd2f5031f9152947bb958a51fee5898d8c"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdbf3cb671dcfcf6c645acdb15ee715d4f48bc4edde86073c5eaa0ed617cbe0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1a7438b2de489266a2ec85738239f82288b7c09bf8b5439ef914b696a4a0d5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "073a8a5d86436c237d4aa496252256f43b5164fa295ec20b7e1da7d6e444fbc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98101329270fb7e2362897b8ad692c0cdc9c596f114b2b44a64e8f9597e45c09"
    sha256 cellar: :any_skip_relocation, sonoma:         "15d8a30c228be1fc5f3b54cf12712ecb4a5525fc6d1dc228445bb1bf50d83050"
    sha256 cellar: :any_skip_relocation, ventura:        "0c14de8159ec0d1b3f6318a2f525f989d4cc19542ab6557eafb5254c057802db"
    sha256 cellar: :any_skip_relocation, monterey:       "4bcc2f31f01a59a23f4bb25cf6e687f0ac673305e3464b6465a0ecdc8aa6d682"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f3f3efe671df2e74868a869267e2a0f8f2103d2ea72773ec2ad57b4cbf4ad7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a72c32bdecf839348c6ac89cdf29742b0c3e7909dfd6dbdbb3dcd12f5c73e009"
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
