class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "9e0ad4d09001acb7021aa2c550f1859574b543cb298771eac8e24a1e29eabe2a"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    manifest_sha256 "d13a7b3f6ae19eaa973b0ee0c070b9639f734531de163d75cf62674a91f15a2e"
    sha256 cellar: :any, arm64_golden_gate: "a6801fc4cd6ba669bfb3f12918452d548d1aa5eee378fcbe5e62e7ae569946a7"
    sha256 cellar: :any, arm64_tahoe:       "1f23007aacd4cafa895ecc29f2c4c1f4c3082955a19f5b1b72581bed0e82a385"
    sha256 cellar: :any, arm64_sequoia:     "e917f008af491cd8e155dd3f5534215aca7bd4d3474bae4904ec36d15b182274"
    sha256 cellar: :any, arm64_linux:       "450e449cdd4ca706cdb3d7f108eb942339beacd11ad133f869b6adba71cc9332"
    sha256 cellar: :any, x86_64_linux:      "bc251004f44e01f65d7c675455e1a1217bb51821daa172a8602214aa19e96542"
  end

  depends_on "crystal" => :build
  depends_on "help2man" => :build
  depends_on "bdw-gc"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "pcre2"

  on_macos do
    # GNU install (Makefile uses `install -D -t`); Linux's /usr/bin/install is already GNU.
    depends_on "coreutils" => :build
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    # Fetch the shards, the web UI's JavaScript libraries and, from 2.12.0, the libgc source
    system "make", "deps"
  end

  def install
    ENV.prepend_path "PATH", formula_opt_libexec("coreutils")/"gnubin" if OS.mac?

    inreplace "extras/lavinmq.ini", /^data_dir.*/, "data_dir = #{var}/lavinmq"

    system "make", "install",
           "DOCS=",
           "PREFIX=#{prefix}",
           "SYSCONFDIR=#{buildpath}/stage/etc",
           "UNITDIR=#{buildpath}/stage/systemd",
           "SYSUSERSDIR=#{buildpath}/stage/sysusers",
           "SHAREDSTATEDIR=#{buildpath}/stage/var"

    pkgetc.install "extras/lavinmq.ini"
  end

  service do
    run [opt_bin/"lavinmq", "-c", etc/"lavinmq/lavinmq.ini"]
    keep_alive true
  end

  test do
    ENV["LAVINMQCTL_CONTROL_UNIX_PATH"] = control_unix_path = testpath/"lavinmqctl.sock"
    # Disable the TCP listeners, which the network sandbox doesn't allow
    tcp_ports = %w[amqp http mqtt mqtts metrics-http].map { |listener| "--#{listener}-port=-1" }
    pid = spawn bin/"lavinmq", "--data-dir", testpath/"data", "--control-unix-path", control_unix_path, *tcp_ports
    30.times do
      break if control_unix_path.exist?

      sleep 1
    end
    output = shell_output("#{bin}/lavinmqctl status")
    assert_match "Uptime", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
