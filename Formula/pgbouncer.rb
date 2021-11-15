class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.16.1/pgbouncer-1.16.1.tar.gz"
  sha256 "087477e9e4766d032b04b7b006c0c8d64160a54141a7bfc2c6e5ae7ae11bf7fc"

  livecheck do
    url "https://github.com/pgbouncer/pgbouncer"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6265ece64ed901a2646b09af720353630e645342a785ae9561c25d65fc11892f"
    sha256 cellar: :any,                 arm64_big_sur:  "bc48b321d3f1f2e4b8a4c6c9665c55945d83ae3975287888460e5e6eb5d5b71f"
    sha256 cellar: :any,                 monterey:       "acf061f094b6d05ca5e2224e114dd50f75dc921bfb43c21a69aa680b419c919c"
    sha256 cellar: :any,                 big_sur:        "63ed65039f2fcd7884a7b163c92747837adb19c2f680a449e1a026d0934bec1a"
    sha256 cellar: :any,                 catalina:       "b929b536892a66052c5da82d02c6fe56dbfd5df79317e0b8508fbca24ef781e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3cc2d2fa16d3a53f452eb38e82d78159a42ae5b205147e47f9f090653e18199"
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
