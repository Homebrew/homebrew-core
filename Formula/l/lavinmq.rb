class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "b81aee386d797c06d2c9aad62e526e6d8458eb1873bb8c3928cfe45d0c7a8ae3"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "94f5c107bbb19d047acbcee2483efc1c48009aafba27bfce7057e51a3d0fa037"
    sha256 cellar: :any, arm64_tahoe:       "4a9f574ee48a67bcb3262566224a70363713bd37913879f5d08a5c657d45044f"
    sha256 cellar: :any, arm64_sequoia:     "4d9d544e7d5a01e8dbc80a4584385ada2e1bcfb3fcae04716ab8088e4125bfe2"
    sha256 cellar: :any, arm64_linux:       "6a18eda3f109fcdcf1270d5d8cb8fb93ed5b8040a96702b492056a2e86872567"
    sha256 cellar: :any, x86_64_linux:      "06bb6c2a5c2a292c73531cf3d82c41b399e5971ed19e78871d544e5a0f26635e"
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
