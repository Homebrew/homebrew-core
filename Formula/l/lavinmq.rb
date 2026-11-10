class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.10.5.tar.gz"
  sha256 "41c6d80c59fb1b9a5837bcf6c4def1458e2c9b8159a665d0c0cb217bd82fa8b8"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b9c95ec7ebca71eda11ae2369624796afe8b98b7b9bd1466fad8956c6d4b1d26"
    sha256 cellar: :any, arm64_tahoe:       "c97a14c3c350993b8e11d8fac6b3618990367899697a10a47e615b159c4ee445"
    sha256 cellar: :any, arm64_sequoia:     "85fdc87977d1031112c0dcecb04852452c9736648ea63a36f2727f15aad2be54"
    sha256 cellar: :any, arm64_linux:       "d9d7703c1aa174a9154351975f4e4b39302977cf5872d0ae77c0042be724f38b"
    sha256 cellar: :any, x86_64_linux:      "8153d5cf41d673976ea9008e5bfcc6edf9689d009d45cd019bbcb3f8ef147296"
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
