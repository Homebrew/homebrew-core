class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.19.1/pgbouncer-1.19.1.tar.gz"
  sha256 "58c3eff9bb72c18133b28e1f034fd59356ea76281c65e127432ca101c208a394"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "393523f1924078f921d3f7a29066c3befdc27ed26ed7627302549fcf2ba2ea33"
    sha256 cellar: :any,                 arm64_monterey: "4b816cd82cedf64c2ed6945bcb49536ac9dae107b90fa56d076b7a282ac5ebe5"
    sha256 cellar: :any,                 arm64_big_sur:  "2605e300ce077a27a10ada91b860be3e48c2a107509f82683dab264e0190f917"
    sha256 cellar: :any,                 ventura:        "d2b6e4f6fe104b37e3f21104479849b24937e8a25f88ff27d46aca65f1cb2535"
    sha256 cellar: :any,                 monterey:       "47f61475dc86a232d2e3625774ea36e1e8f6d4cd040ce65ee3d7435eea4cb93d"
    sha256 cellar: :any,                 big_sur:        "6045d6c8033af6892a212e91048c9ffc246130efec6e6fd5e89663fc65f98df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82dea8700a650af2016ab7cc5213fef97419936b257542b5a219ed59d16c4608"
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
  depends_on "openssl@1.1"

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
