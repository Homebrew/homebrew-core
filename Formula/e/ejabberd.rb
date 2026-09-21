class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/26.07.tar.gz"
  sha256 "7b2e4efe2d5c867d2ced9cb1391731c5e6b9accd6f166ec71e734a3ae97813d7"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/processone/ejabberd.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "119f9e2e3fb9caf7824712fb47b6c4e183213983bce45489cc8ac1f83430f579"
    sha256 cellar: :any, arm64_tahoe:       "7392a38aea2dbeec29d98ee5010acf9046ca0968c99014c96cdfa14f25abad9a"
    sha256 cellar: :any, arm64_sequoia:     "8537f2664cb8e8179fd1fab136fe2e8cb68575d3b0b612ba07161268829910e3"
    sha256 cellar: :any, arm64_sonoma:      "1dca086a9ab019f8927735ed0e2b0324ba3a1eb1f5c6ac216de9f476de2e3c62"
    sha256 cellar: :any, arm64_linux:       "01035a43dbda58abfd1521426371fdc33356eb0c1b239ed82547c45b587b5084"
    sha256 cellar: :any, x86_64_linux:      "cfc59032c3e8c3d7317733d6d9366b11dfb6ecd9b95770b2a8abd68b9f259424"
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
