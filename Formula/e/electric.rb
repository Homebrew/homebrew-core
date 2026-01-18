class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.3.0.tar.gz"
  sha256 "e51539895868819b5ee98e0b12ec3ed1c04bbaf72efa0b8b8bed4220e4f18cdc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "caeece9daa5ad0ebe0281100b5f9c7842b1228d8e038fa4ba6c1227c2f0fa839"
    sha256 cellar: :any,                 arm64_sequoia: "1d207a701b6c45d7d85af9a00724015a035f9ef0f53b505a68f8b8c56c929198"
    sha256 cellar: :any,                 arm64_sonoma:  "cadab0aa14dc94df25c6c77986f8c9719b4132ed30cd02e802659cbbe5603cab"
    sha256 cellar: :any,                 sonoma:        "8ba9cc8f05aaf7a2b6f855447b3070b3f26f0373dfb82c9ee50bcf47d1c94046"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee2630d6e4fe0252be099a8b82b1a47839253bd6fe2bb856f5421fd78634626a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad19c6d1c68d26f52440d7a365a02e61cd7323bd9c23a23b2a4e746c197bf7d7"
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

      mkdir_p testpath/"persistent/shapes/single_stack/.meta/backups/shape_status_backups"

      spawn bin/"electric", "start"

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
