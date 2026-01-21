class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.3.2.tar.gz"
  sha256 "46e858e199962c0141af5645f5e85654bbb1ba6ec94d02dcd901db9199ec7008"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a468b99a0e87d1d3e7a0dd4de8ce65f858aa91e1b1f355db3f18e6475f23b83a"
    sha256 cellar: :any,                 arm64_sequoia: "4ab9ff4daf04b2089d9cf1e3c4cfde8e3253e99f71a268afb3f2b8b2e9cc71ba"
    sha256 cellar: :any,                 arm64_sonoma:  "cccfb3bd050f399eb11a6f4c926a7211ebcefbe92bbe45952864f06f41aeab3d"
    sha256 cellar: :any,                 sonoma:        "1175ab42ecbeace3b8f9a0fd28048f2251d0c6754e7c02adff7f6908c125c8d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f5e78a87878f5036c7026d2c1bd91239bb2aa6908c9f47d6fda8a1abfdea976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18f7fdde6a52c233ff0b40504e992f1449ca8500081174665349c8537022bb67"
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
      sleep 5 if OS.mac? && Hardware::CPU.intel?

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
