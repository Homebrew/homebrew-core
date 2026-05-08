class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "ce9ec3095adf41dcaa0b99649109fb97abbb0ef98bed639e2bf7881149752dcd"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e358f0247913f8603d9994e993c52db1e169e843b6bc5afeed310007f1862c11"
    sha256 cellar: :any,                 arm64_sequoia: "b59b00f6bfe4d275b53e1abe194386c6c6fc7f145571579a5777f621ae436db7"
    sha256 cellar: :any,                 arm64_sonoma:  "25d3560938c6d21351824abd61319bcbd01ca3216b04a3a56218b5db991e79e1"
    sha256 cellar: :any,                 sonoma:        "fedd7f4cd9279e688283448adcde7431b15f8ea18101f79d8e2448f613ef25c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bf297520031bf30b3f92000e47401d3f6c69c88a6575b1ca04e54f03478bfb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc4566b0830e93f55c776162b0950cca0134d2b744e1185854097f8648a9866"
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
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin" if OS.mac?

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
