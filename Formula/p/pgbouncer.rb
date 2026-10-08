class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.26.0/pgbouncer-1.26.0.tar.gz"
  sha256 "afd25dd61ee6775d37b40629b87ce08736b3e6955f3057bb212e410fbf21c71d"
  license "ISC"
  revision 1

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7f864d2b7c89876a6743ae610d59a0e632f01bb504bf25c2d122962b042b1096"
    sha256 cellar: :any, arm64_tahoe:       "4c47024fd069e6f55937d59ce37541fefa506ea8cb514d857b730208505f1517"
    sha256 cellar: :any, arm64_sequoia:     "bad6fd2122f8dd5506b27a02b6333053fd8298e429476b90299c5d7ce5942d96"
    sha256 cellar: :any, arm64_linux:       "e20d79043f76221b5bf1e7d487f98a00f805a08660934cc1ef12347a32cfbf61"
    sha256 cellar: :any, x86_64_linux:      "d5b2160609831572bb72e72a8a81fe41a345af1e2ee2bc607b128ab278d51f70"
  end

  head do
    url "https://github.com/pgbouncer/pgbouncer.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@4"

  uses_from_macos "python" => :build

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
