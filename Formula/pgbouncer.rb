class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.18.0/pgbouncer-1.18.0.tar.gz"
  sha256 "9349c9e59f6f88156354f4f6af27cdb014a235b00ae184cbaa37688bd0df544c"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3fe9d8e3e59e1117eeab41e90b04e5e39e0e6115192abf1f526b91da8df028d4"
    sha256 cellar: :any,                 arm64_monterey: "74f34bbf272664b4084317b8dc465c89ebd5586c8b18cb32b36124303e01bab5"
    sha256 cellar: :any,                 arm64_big_sur:  "615addb44732127a561afaacf3f182d538c909eec359e8246e0c77ab4f9a84af"
    sha256 cellar: :any,                 ventura:        "c2f1d02f00d9db6c3223c962812e508893bb91a817205f86e6907c4488ee29f8"
    sha256 cellar: :any,                 monterey:       "4569805015dce13a90bda65225a1def60e430822d94e813176df6e00d9ae6ef8"
    sha256 cellar: :any,                 big_sur:        "3a358136afda3ec3fbb98fdc6dcd36f94b12de4dde564cf41b6350c19da21558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0efe7f41310bb853ef0ceafbcfd74d3109076812b2843cf4d388b1ab366b379"
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
