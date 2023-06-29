class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.19.1/pgbouncer-1.19.1.tar.gz"
  sha256 "58c3eff9bb72c18133b28e1f034fd59356ea76281c65e127432ca101c208a394"
  license "ISC"
  revision 1

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c83918bfdc2f4417c2fbf800559e6df5021dda36eae3053cf9adcf4c619b813c"
    sha256 cellar: :any,                 arm64_monterey: "278ce6acdea42a0dd938f94f782371f145c2ab9d05adcee8a286523380bba002"
    sha256 cellar: :any,                 arm64_big_sur:  "4ff5a127cee4cf8486de2781f092bc1c496db3cb54ee1048b8158944199a34cb"
    sha256 cellar: :any,                 ventura:        "aa158ba4b6b88c41565413707557ba0b5beccdf1cf5afb709868c082e6b0922a"
    sha256 cellar: :any,                 monterey:       "887fffbd48391fc40335fb5a550a54d3d70077611e48c7f8fe26f990fec9c7b8"
    sha256 cellar: :any,                 big_sur:        "aa4c4fc052f4b90c64a10df4c57edaab4131aa96ae29724f297976713a623d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbb0ca0c629314580e52f69aeb73eed423fc6e557b217ae75ee040e7581a76e7"
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
