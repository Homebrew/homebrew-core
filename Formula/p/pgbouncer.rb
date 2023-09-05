class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.20.1/pgbouncer-1.20.1.tar.gz"
  sha256 "24992cf557d73426d7048698dffc7b019e6364d4d8757ae2cf5e2471286a2088"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a94e496cf7ebbf7e0dd1bdcb4425c9d963db8068d0facb4b5cc8184d05d88f75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "324e78695be835d58010fd647152733778178e5ef9197d81fdd024eabcaf979f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2daded50db318c8083bf5aa1bee66b78a25914f068111c395054e47cecfcf44"
    sha256 cellar: :any_skip_relocation, ventura:        "8df99b1040fd67c08f09205261ffadfc524a05be9661559919bbb42d476a80ab"
    sha256 cellar: :any_skip_relocation, monterey:       "71cdcac59c53ec9c3a05f7483a49329c8b77fd64587020e0beb991e674da3d60"
    sha256 cellar: :any_skip_relocation, big_sur:        "16c60979ed52c2b00c246f590188deb7aaef2a0d56370bbdd80addcd7ad49cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "428d8a811c4920e767ac1c70866f32988947df6692727783c596a244e729b10e"
  end

  head do
    url "https://github.com/pgbouncer/pgbouncer.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pandoc" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
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
