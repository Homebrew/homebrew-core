class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.2.1.tar.gz"
  sha256 "dca324ae6e8552c2c03aaf895ab66ca839f4b76b3d1190b21cf10f4c755dd056"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dee0f092274f70060add0d41ab16a5ef50fb659a9b9796e2d614ef4b27d05908"
    sha256 cellar: :any,                 arm64_sequoia: "38782f35410e86a3c1e5a38b0d6630e8d994574247ef4cd6ad2bcf05ea21cfdc"
    sha256 cellar: :any,                 arm64_sonoma:  "efd5e022343c89fcd6b67eb718d5aeb8c271b9f0a85dcbf5730141a552bb6a3c"
    sha256 cellar: :any,                 sonoma:        "807658746e000837f05e4698a75349222015dbcc9349c950372858f4fc76970b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9c1cf804df5bb212ec145cdf6c789739629f968dfd7a62d1287d30299fca5c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b28de78d1501c59aa73e3b1c09211a95bb1e6c5471a5abdcb29ccb1d9c8eb51f"
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
