class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.10.6.tar.gz"
  sha256 "5a452e63849a4ccb1bffd1b0a90f7320e1788f4658374d36320b095923a2f27c"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "390ecb6bef2592a7c7b5ae4fb355ac9c8d8a21d0acc1030c19aa59e7493a4579"
    sha256 cellar: :any, arm64_tahoe:       "332957781df1f5d8f764d1f8ae22aaa08fd3ed04432324e7ea24520ad9c56770"
    sha256 cellar: :any, arm64_sequoia:     "2042895f71a86d64e6d3f706723c1498ba15b507675afcc259a614ef532c3d80"
    sha256 cellar: :any, arm64_linux:       "1d25b310438ba7ddb9b7a4c8e66ab9ae7fa5d47286582e99c9e7e8e72674ba7a"
    sha256 cellar: :any, x86_64_linux:      "95e232543c4a99c27f45cb9ed04d2d63a9509fc705aa79fb28a651157a456808"
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
    # Fetch the shards and the web UI's JavaScript libraries
    system "make", "lib", "js"
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
