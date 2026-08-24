class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/26.07.tar.gz"
  sha256 "7b2e4efe2d5c867d2ced9cb1391731c5e6b9accd6f166ec71e734a3ae97813d7"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/processone/ejabberd.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b309a064ee108b15b35fa1feda4001aa06f894a68f0f75bf5a39916c28e6e0c1"
    sha256 cellar: :any, arm64_sequoia: "19cd1c281bd69940ccde4a76331d029afc9846d55335c5802f01e4149ca5f598"
    sha256 cellar: :any, arm64_sonoma:  "746e4d31d4bab7976963cdaad524fc59d2349a12be32ce2b814eb1480789ec9f"
    sha256 cellar: :any, sonoma:        "949f8430d68da474f60368edff9d294994b9bdf80c328726c602c4ec292ddb88"
    sha256 cellar: :any, arm64_linux:   "332d39cfc9bf8c62898a835ba49326d2e856dc9330e6d9e2b019b32872ddfe96"
    sha256 cellar: :any, x86_64_linux:  "42e7067209508b0a2beb7d11bccfba5766879370673a5536bb059d42c29cadd3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "elixir"
  depends_on "erlang"
  depends_on "gd"
  depends_on "libyaml"
  depends_on "openssl@3"

  uses_from_macos "expat"

  on_sonoma :or_older do
    depends_on "coreutils" => :build # for sha256sum
  end

  on_linux do
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "couchdb", because: "both install `jiffy` lib"

  def install
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-debug
      --enable-pgsql
      --enable-mysql
      --enable-odbc
      --enable-pam
      --enable-system-deps
    ]

    system "./autogen.sh"
    system "./configure", *args

    # 26.03 Makefile runs `invites-deps` targets in parallel, which can race
    # on bootstrap zip extraction in non-interactive environments.
    ENV.deparallelize

    # Set CPP to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    system "make", "CPP=#{ENV.cc} -E"

    system "make", "install"

    (etc/"ejabberd").mkpath
    (var/"lib/ejabberd").mkpath
    (var/"spool/ejabberd").mkpath
  end

  def caveats
    <<~EOS
      If you face nodedown problems, concat your machine name to:
        /private/etc/hosts
      after 'localhost'.
    EOS
  end

  service do
    run [opt_sbin/"ejabberdctl", "foreground"]
    environment_variables HOME: var/"lib/ejabberd"
    working_dir var/"lib/ejabberd"
  end

  test do
    node = "ejabberd_test_#{Process.pid}@localhost"

    ENV["EJABBERD_BYPASS_WARNINGS"] = "true"
    ENV["EJABBERD_CONFIG_PATH"] = testpath/"ejabberd.yml"
    ENV["SPOOL_DIR"] = testpath/"spool"
    ENV["LOGS_DIR"] = testpath/"log"

    (testpath/"spool").mkpath
    (testpath/"log").mkpath

    cp etc/"ejabberd/ejabberd.yml", testpath/"ejabberd.yml"
    inreplace testpath/"ejabberd.yml", "port: 1883", "port: #{free_port}"

    output_log = testpath/"output.log"
    pid = spawn(sbin/"ejabberdctl", "--node", node, "foreground", pgroup: true, [:out, :err] => output_log.to_s)
    sleep 5
    assert_equal "pong\n", shell_output("#{sbin}/ejabberdctl --node #{node} ping")
    refute_match(/ERROR/i, output_log.read)
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
