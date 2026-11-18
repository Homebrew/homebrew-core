class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "b81aee386d797c06d2c9aad62e526e6d8458eb1873bb8c3928cfe45d0c7a8ae3"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "ddb7f618f81937bc92023b8abc77e6832e17d1d92df7f20b7d49f4e2fc862751"
    sha256 cellar: :any, arm64_tahoe:       "2edf7a057f64e617921f1dce99a19b38314dcc8960a6c106bcf900cf8e5656c9"
    sha256 cellar: :any, arm64_sequoia:     "b9ec880f67447340697d2b763a127083bf67139bc4b528595a837e14fa576b2b"
    sha256 cellar: :any, arm64_linux:       "179b672807d48556447ec791aaf2fc1f3c3a62401138d28305f34535f4289d03"
    sha256 cellar: :any, x86_64_linux:      "58a2623ae3cb15438061f27d71047a6a0379a9545b084fd62921adb52d3121bc"
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
