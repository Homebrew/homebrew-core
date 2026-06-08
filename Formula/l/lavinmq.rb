class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "f2d6ecf550801c369ab2d54eb8faa64b062d7b5e668d646ec19f2459568b6a27"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "963dcede02370a1255c44fd6215f3805673dfadcc240b7d9bdf06e9687e480e1"
    sha256 cellar: :any,                 arm64_sequoia: "0f1011dab08d17e4db32b8a3cbac4ce7dcb51a4bf50574b7316e20ff88db208b"
    sha256 cellar: :any,                 arm64_sonoma:  "b43a1158edc0fdae31c3b6e6aaa1123530f7f733951e58c262782bf641eaff5f"
    sha256 cellar: :any,                 sonoma:        "0b879ecbd95e1fdee5b1c6bf67394b17a5542eb94571898df06bde2d662ae41d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c22b9dc72645fbd539480e0b7609949c43f77d55a937140625cd33074e75af89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "938be77a1a2074ad69b89130089aa8fc90e763b1398d9da4592d3f339439615e"
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
