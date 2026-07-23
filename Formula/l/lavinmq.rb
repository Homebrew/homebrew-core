class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "b9efc1df449904e4be99c86127a9d821720fc93e7c1ebc8765d826809bb652ca"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1dfbf97ec078c055bdfcbc13f8f49c1645a64733aa4fbbd99b79ab17b05be63a"
    sha256 cellar: :any, arm64_sequoia: "623930da189e1d99c05f81619e192451e9a0757dab1f372de0e1bf7421544838"
    sha256 cellar: :any, arm64_sonoma:  "f9bdb129e8e7378566f8be0f371f333711fc61e3a659f44f0cce9891cb5c3d33"
    sha256 cellar: :any, sonoma:        "23543da8daff3fa4903301d38204045050be1c4499aaee78ec58b446def91954"
    sha256 cellar: :any, arm64_linux:   "d79193d725d231f6e211737c2a3987f9d0c339395e461834a327a1a78ca550c5"
    sha256 cellar: :any, x86_64_linux:  "28f70e9fea0cabb64b27bcec793bbf6cf789daefba400cd9c6910b1f14f9ba7f"
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
