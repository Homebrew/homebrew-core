class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/26.09.tar.gz"
  sha256 "2853a0ccafc0343ba47a3a848267fd9971c521d594a29c4caa8114bc511f10ab"
  license "GPL-2.0-or-later"
  head "https://github.com/processone/ejabberd.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "66b8495dea8063935e5bca3c2b30084455a35212c1fe51011f7bc1aebe7351c7"
    sha256 cellar: :any, arm64_tahoe:       "e07909261f40164522b2bf1a94b9cfe41c83e9ebf5e1f59627b3b2eefed90329"
    sha256 cellar: :any, arm64_sequoia:     "7362cc0b5087e94cebe20a4756af5e314603cc663a73b60332d00a57830751d2"
    sha256 cellar: :any, arm64_linux:       "80d5d135529694ca90a6dae948151884fbd7d22dfd93a707ac45690345d2b734"
    sha256 cellar: :any, x86_64_linux:      "0ccb4d1beb39ad5dabd1b932bc7d4514ed8765760238c29fefd64a82ac6aeec3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "elixir"
  depends_on "erlang"
  depends_on "gd"
  depends_on "libyaml"
  depends_on "openssl@4"

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
    ENV.append_to_cflags "-I#{formula_opt_include("openssl@4")}"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("openssl@4")}"

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

    # Makefile asks `elixir` for this and gets a versioned Cellar path, which breaks on every Elixir bump
    elixir_libdir = "ELIXIR_LIBDIR_RAW=#{formula_opt_prefix("elixir")}/lib/elixir/lib"

    # Set CPP to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    system "make", "CPP=#{ENV.cc} -E", elixir_libdir

    system "make", "install", elixir_libdir

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
    # `ejabberdctl` execs `beam.smp`, which outlives a TERM sent to the script alone; signal the group
    Process.kill "TERM", -pid
    Process.wait pid
  end
end
