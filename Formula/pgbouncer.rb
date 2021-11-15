class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.16.1/pgbouncer-1.16.1.tar.gz"
  sha256 "087477e9e4766d032b04b7b006c0c8d64160a54141a7bfc2c6e5ae7ae11bf7fc"

  livecheck do
    url "https://github.com/pgbouncer/pgbouncer"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ed28e5a42d5212fa39c4f5906b93bea54eed6ed3a7f0df89dd7596ce4190afa3"
    sha256 cellar: :any,                 arm64_big_sur:  "296a29f3cbfc6913fc9fdd0ebfd3a0f5475b74a781192b869fcb6757e919c879"
    sha256 cellar: :any,                 monterey:       "c253e4a238780e44ac2aff1873ed9750a671ef9960014c078627ab45ed8cdb7d"
    sha256 cellar: :any,                 big_sur:        "7d61dac174635767840b8dde46b2d9b4b25f6a36fc5ac950beb0868366fa87b8"
    sha256 cellar: :any,                 catalina:       "e9bcdece7ed67566382ed196d34f6550fd093519e0283cb5e6170bd66645355f"
    sha256 cellar: :any,                 mojave:         "d6e080c159196a61edd69c73ea234ce34bc91baeaf25e814633d2b35cabfb496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26f5a2974400ec50e0727ce1b3054ceacd83e2e10e6b65e0e92296f412c65bfb"
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
