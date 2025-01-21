class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.24.0/pgbouncer-1.24.0.tar.gz"
  sha256 "e76adf941a3191a416e223c0b2cdbf73159eef80a2a32314af6fbd82e41a1d41"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87aa1ebe4c4245e0864976983b532be084388ed482fc9795a2503a5d874e27f8"
    sha256 cellar: :any,                 arm64_sonoma:  "43a76e841d08d4e0448795dffa6c9f69dfc86b2375a9e0557952d5ae5ed8605d"
    sha256 cellar: :any,                 arm64_ventura: "1f405a92d760c6af0756ba2b32966d73ce9d4cffce462ac332b3d98f1b3b5f48"
    sha256 cellar: :any,                 sonoma:        "262b7ed2c5749f2921add6f3065d367be16fc721f65c5bd48d04b3a08045a494"
    sha256 cellar: :any,                 ventura:       "bcede5ab58af987fa0e16e4dd44ba4bb0356671459859783c2112d67856efbe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d527e71fdf0028f6c281340e00462adfa848939d20abe32a6c94ecb65a9be3"
  end

  head do
    url "https://github.com/pgbouncer/pgbouncer.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pandoc" => :build
  end

  depends_on "pkgconf" => :build
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
