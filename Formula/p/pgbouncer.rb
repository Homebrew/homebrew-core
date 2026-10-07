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
    sha256 cellar: :any, arm64_golden_gate: "32e98d8a2e2b279c09cf25634901bf3fed2cd1dd5ab6ed2dbd1b89aabfbdf6a4"
    sha256 cellar: :any, arm64_tahoe:       "6e246b133ceca897407df93be55de6b722f27b6a748543a1b878f76c3b7c0a46"
    sha256 cellar: :any, arm64_sequoia:     "a6b0aa57499c8c6e9126112c0825e44ba61418d44e0d9d44118f81718a9eae15"
    sha256 cellar: :any, arm64_linux:       "7dc4555712ce383a6a197648e765604efbbe7de0c65e2d00c0f8d42c201f23fc"
    sha256 cellar: :any, x86_64_linux:      "5fa16c1cbd2d23b28f30bdc2d27cc49f3376cbe76d839600afe096e3ac82fdcd"
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
