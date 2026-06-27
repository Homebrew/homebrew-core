class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "2d7e4edc22f6acda2a77c66fca8179a5c2aacfd9d454063e30314ea8efb24c15"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "668c7a118124810de0646810bb545103ee39018bfbd9b23887bc9c208461f8ec"
    sha256 cellar: :any, arm64_sequoia: "c8a13dd102f40192a2ad2372088c7e3082de12a840149709fa65c1af8f222ed1"
    sha256 cellar: :any, arm64_sonoma:  "94338bf938807e1278bf75329c2de2b365f037423d4c8f75b220c2a9d461a35a"
    sha256 cellar: :any, sonoma:        "3cba2de138aae3696e6839f5274e6f85c74bc07e13c6883643c5264abd8fbd48"
    sha256 cellar: :any, arm64_linux:   "4d1956f6041ee109d75848ac81b29c7d94363441fb496bc2a092e6133338eeb7"
    sha256 cellar: :any, x86_64_linux:  "42a780215dda10ba8e1d1ca6598882e0a0390d36d257f68c084ac1cba2dafd62"
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
