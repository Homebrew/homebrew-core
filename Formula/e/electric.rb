class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.4.7.tar.gz"
  sha256 "7ef02eb13fbb2a8e817b92931e7da1ad88af9a2f70e5f0aea979ed558246bced"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b2f6fe2d8140c60a21a6b5368011ce4354371fb273f48ca28299febbc48ad5b6"
    sha256 cellar: :any,                 arm64_sequoia: "0c7614a5f44ee4e58141fce50746ef95dcd948aaacdc9f806fa325d2ac28782b"
    sha256 cellar: :any,                 arm64_sonoma:  "62e454b6ea6aa3eadbfc7f0f3463c615bf6c25a7de0c8226ea93ebc5017d8063"
    sha256 cellar: :any,                 sonoma:        "bae94d71607d001a5c7aa3791ed8e2250d3701d91c566e580b85df8101b560d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d313f5eb4dfc36a51bf88af6ce296f0783007fe5d045a82abc84866c7373a7e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d178abf35a03192d854dd437fa4ce9b7f81099bc935248c3302c8fe46d33397"
  end

  depends_on "elixir" => :build
  depends_on "postgresql@17" => :test
  depends_on "erlang"
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      sleep 5 if OS.mac? && Hardware::CPU.intel?

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
