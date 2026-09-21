class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "a6f14b3a6b4d80a4e58b4a46124522d79390588025c97ab5c290a0fe6cf0262e"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0df9309468faf135855f8277ab5965c61b7e65e3698c3c23063b77b43f7e9c52"
    sha256 cellar: :any, arm64_tahoe:       "8f0a48331fe09e37a123fe76d60919adbd187c8cdd45ab0a1abae89f1b947bca"
    sha256 cellar: :any, arm64_sequoia:     "2e8c020b0d2d9830bf69b6ee6e748b4fc296c7713f395c5ed9d55ee502c38405"
    sha256 cellar: :any, arm64_sonoma:      "fa2661113c90ed56235daf7968d6cb7dd485c30dc3f0ae74997fcf3a4e58a095"
    sha256 cellar: :any, arm64_linux:       "0ff998fddaf9b9439aec2b53c86e4fcbb7681947c8cb986590b9c0d87810e45c"
    sha256 cellar: :any, x86_64_linux:      "fd70bbab0e1c0372b4d29192bf4f9412e1a71f48bbf7e5c3581e614f9bbcaf4e"
  end

  depends_on "crystal" => :build
  depends_on "help2man" => :build
  depends_on "bdw-gc"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre2"

  on_macos do
    # GNU install (Makefile uses `install -D -t`); Linux's /usr/bin/install is already GNU.
    depends_on "coreutils" => :build
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zlib-ng-compat"
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
    pid = spawn bin/"lavinmq", "--data-dir", testpath/"data", "--control-unix-path", control_unix_path
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
