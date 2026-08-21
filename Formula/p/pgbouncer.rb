class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.25.2/pgbouncer-1.25.2.tar.gz"
  sha256 "924ad35113fd0a71c8e2dbe85b5d03445532e2b7b37a9f8a48983beea238b332"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4d3afb213297e0fe071af4635a3225f45f27ab3a449c53663b34bc7efe9f644"
    sha256 cellar: :any,                 arm64_sequoia: "1b328b87cabcc6161a51e61071e02f244a309335f75fb4f4441b1848651379b9"
    sha256 cellar: :any,                 arm64_sonoma:  "e4369885ecf75d2d7dd9682a0b031dcf25d7edb569d6f93d8f3258bd87cd313e"
    sha256 cellar: :any,                 sonoma:        "a95d4cae40c8395f9208bb5a780cd733536c82f1a44f30ca368e62da5877c78b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7353981ba4bafe80874718e0019b76f406afb220e8429ad4f27ddcd01990b2c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f93d001a0478a33b1660a611a60155824f8f69a978f1d974e020e7cee42a3ee"
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
  depends_on "openssl@3"

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
