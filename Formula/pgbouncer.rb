class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.16.0/pgbouncer-1.16.0.tar.gz"
  sha256 "a4a391618bb83caaee2a8cd9653974f4c1b98b95987d5cabbbeb801da6342652"

  livecheck do
    url "https://github.com/pgbouncer/pgbouncer"
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "296a29f3cbfc6913fc9fdd0ebfd3a0f5475b74a781192b869fcb6757e919c879"
    sha256 cellar: :any,                 big_sur:       "7d61dac174635767840b8dde46b2d9b4b25f6a36fc5ac950beb0868366fa87b8"
    sha256 cellar: :any,                 catalina:      "e9bcdece7ed67566382ed196d34f6550fd093519e0283cb5e6170bd66645355f"
    sha256 cellar: :any,                 mojave:        "d6e080c159196a61edd69c73ea234ce34bc91baeaf25e814633d2b35cabfb496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f5a2974400ec50e0727ce1b3054ceacd83e2e10e6b65e0e92296f412c65bfb"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
    bin.install "etc/mkauth.py"
    inreplace "etc/pgbouncer.ini" do |s|
      s.gsub!(/logfile = .*/, "logfile = #{var}/log/pgbouncer.log")
      s.gsub!(/pidfile = .*/, "pidfile = #{var}/run/pgbouncer.pid")
      s.gsub!(/auth_file = .*/, "auth_file = #{etc}/userlist.txt")
    end
    etc.install %w[etc/pgbouncer.ini etc/userlist.txt]
  end

  def post_install
    (var/"log").mkpath
    (var/"run").mkpath
  end

  def caveats
    <<~EOS
      The config file: #{etc}/pgbouncer.ini is in the "ini" format and you
      will need to edit it for your particular setup. See:
      https://pgbouncer.github.io/config.html

      The auth_file option should point to the #{etc}/userlist.txt file which
      can be populated by the #{bin}/mkauth.py script.
    EOS
  end

  service do
    run [opt_bin/"pgbouncer", "-q", etc/"pgbouncer.ini"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgbouncer -V")
  end
end
