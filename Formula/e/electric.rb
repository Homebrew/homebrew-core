class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.1.5.tar.gz"
  sha256 "0ede5be9f13425907f94ba51ca3fa51b7826bafc7a315d379690b0726b85d58a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "784f0abe1ae82be0ae544b96c493705bc3f57d5b55b3b085411fad51006ce47d"
    sha256 cellar: :any,                 arm64_sonoma:  "56e1f4e9a1b0fce23ba1192d1e16e70a1b01b6c624f5b78b58f31b489c2a6eb3"
    sha256 cellar: :any,                 arm64_ventura: "b2e3d9b41b3ef33f9bb68f4a5a30e0ef03a29a2667b16129da35dda489170f7d"
    sha256 cellar: :any,                 sonoma:        "f3ae2b0d5f17f5af6e9054142b8e02af84d2bfdf955dcc50850233f18227f981"
    sha256 cellar: :any,                 ventura:       "d42dfc52cc6cb885f35812ee223aab559ae8a6e879f104f73c5d819d297135e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fac65197794fa00d6264dd7f933e66d20dd1530127277d5ecebd069cb892c864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70f9c8e91ee9aba394f2e03f493c5d1e4e966afe513c6d7676336b80fceb9757"
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
