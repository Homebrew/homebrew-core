class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.17.0/pgbouncer-1.17.0.tar.gz"
  sha256 "657309b7bc5c7a85cbf70a9a441b535f7824123081eabb7ba86d00349a256e23"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "119a5cbc45b33313794a85152531bcb67ab763c02e394bcef6805e9105d426ae"
    sha256 cellar: :any,                 arm64_monterey: "24c0ed2e7272aab2e94b5104d7242795b16f459856af89d16b035f17c1645033"
    sha256 cellar: :any,                 arm64_big_sur:  "f1356d0a3300f049b351b1b2fdb3f93d298c1533091b61048323f3a8788ac1ec"
    sha256 cellar: :any,                 ventura:        "e6885fb2ea3541740f29beb7fc19b0cc88658bab7f867884f51fd03c876a4c61"
    sha256 cellar: :any,                 monterey:       "73da393d7738c2a742dc4d994ace39152312e1d9b8f5d06b1a33d6090e011985"
    sha256 cellar: :any,                 big_sur:        "e382cad5b439674062a98fdb2ac72069b8b1fec351a17e7c9ab886f35b695cf8"
    sha256 cellar: :any,                 catalina:       "758e33e22b99bd1bf02af15564ff829c82cbac74facdd5462ee6f9691e8f24b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1da1373bd7fa36da801193159f10bc9128b82a60a03d9da5b0bcbe35b75f04cd"
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
