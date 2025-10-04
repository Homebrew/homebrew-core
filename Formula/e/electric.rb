class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.1.14.tar.gz"
  sha256 "962e25ca23551ba773f1dd7138dbfdce0ba58aaedeb3eb24005483d39c031e8b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "198f04b9d844ded94540c553c4c37792aed4e42d1412399eaae9a11f99ecc925"
    sha256 cellar: :any,                 arm64_sequoia: "3901f2f791f78bbb3299c6a9f603744105cf0cf38a9aca7cecb70352055a05b9"
    sha256 cellar: :any,                 arm64_sonoma:  "fc6eccbc011b6daca1068882227282d453670c6ff8ea94cdfecfcb4bd82b097f"
    sha256 cellar: :any,                 sonoma:        "3abc942a60b83c6c8090c5c7b1a19b7e36a644e9c8c37981b9b4a85810f07b81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "712fe99cfbe60b49ee1493af2d54859cc8dfd5d8ccbed0250446dcf325e92682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ecb5e0dd671f30693b42a664c1e4c26a7fdc56a0a0135bf04f73aa9c95f6a74"
  end

  depends_on "elixir" => :build
  depends_on "postgresql@17" => :test
  depends_on "erlang"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    ENV["MIX_ENV"] = "prod"
    ENV["MIX_TARGET"] = "application"

    cd "packages/sync-service" do
      system "mix", "deps.get"
      system "mix", "compile"
      system "mix", "release"
      libexec.install Dir["_build/application_prod/rel/electric/*"]
      bin.write_exec_script libexec.glob("bin/*")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/electric version")

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@17"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
      wal_level = logical
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      ENV["DATABASE_URL"] = "postgres://#{ENV["USER"]}:@localhost:#{port}/postgres?sslmode=disable"
      ENV["ELECTRIC_INSECURE"] = "true"
      ENV["ELECTRIC_PORT"] = free_port.to_s
      spawn bin/"electric", "start"

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
