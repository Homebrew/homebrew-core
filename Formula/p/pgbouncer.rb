class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.22.1/pgbouncer-1.22.1.tar.gz"
  sha256 "2b018aa6ce7f592c9892bb9e0fd90262484eb73937fd2af929770a45373ba215"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2c8a0df3a201068e57e77aea1c9f1c506f25353161583b13793489f4319761b2"
    sha256 cellar: :any,                 arm64_ventura:  "3415c3833bea72aa23f47324f83dabd95157c5731a96030fa8018bb665f78217"
    sha256 cellar: :any,                 arm64_monterey: "3ecb564029ab75dd2bf9d6c0e8680037a3a202609197d5b8f9d43f850d3e6ae7"
    sha256 cellar: :any,                 sonoma:         "584688b27acaec506d593568fdb8881504b062cce908137b94db004ea609c1e8"
    sha256 cellar: :any,                 ventura:        "5e23b089ac1fcb25df9040e2d6b79385a67cd90f4b1008eeaa6f2d55241b0f7c"
    sha256 cellar: :any,                 monterey:       "27730dfeb9464f3b90195f49658e98a54639a315dee06181d5924c7ac91bdb94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2f6975477a2800b42d8e4fc85ff0dbf1b12873cd9c9809e7655b3dcd5bc0682"
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
