class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.26.1/pgbouncer-1.26.1.tar.gz"
  sha256 "00886a2994b4844cd37110970df777772cfc42a74c400522c82fba509a3f42d9"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "33ce961a07aabf35bb734bb6e59f95d7e324fc77efb73e3861e02f445811ac06"
    sha256 cellar: :any, arm64_tahoe:       "8823b3d355d1f637a93a5ee495a0f77d5b95c0503730e4f80af7530bfebeef35"
    sha256 cellar: :any, arm64_sequoia:     "2826a9b5bd3784b53a8ffc261da4524fb304cdd5bf401b3f6c8a9c51d3433964"
    sha256 cellar: :any, arm64_linux:       "1b04827ae40fe2a6c0e4387f88e5e2297bc24eda8c7b9889ab038ba88fec1219"
    sha256 cellar: :any, x86_64_linux:      "bb5169f6b1381ab86420e3d67b0ec056e12206a5a55e1db7faf4338d650d9734"
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
