class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "767b738db86ebbb2b04b46975fc338869f1605f8c6f5f6466e08ec6fd4f32d98"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "59968181356952bf1cfd7ba06ad2fca3c4861557ce97f5068966db44cff10326"
    sha256 cellar: :any, arm64_sequoia: "25abf1684b48b13f9db587427f866bbe2e9d5d701a7d4964a6e080558fbc7075"
    sha256 cellar: :any, arm64_sonoma:  "eb6b181af603e5166c3d5861f28c6b8cae359c396d2222797fe475fc88d249d1"
    sha256 cellar: :any, sonoma:        "56d0965432e06ca31f7f1147e2a3574bd3769d9bc31b652e91b0e30ffe248878"
    sha256 cellar: :any, arm64_linux:   "e0e08bc4a212f9aa1c33e8a18594e5f93d1f1faddb148f2a3f55c9d9f2598433"
    sha256 cellar: :any, x86_64_linux:  "c841a9cccb8c7439b813774caf25c100a8ba48bf944e4d0664ac0ac063ebdba8"
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
    pid = spawn bin/"lavinmq", "--data-dir", testpath/"data"
    30.times do
      break if File.exist?("/tmp/lavinmqctl.sock")

      sleep 1
    end
    output = shell_output("#{bin}/lavinmqctl status")
    assert_match "Uptime", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
