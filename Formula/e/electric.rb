class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.4.5.tar.gz"
  sha256 "946f7eb6e01a7244e84c8294a1b48a05471d89b5df3bbbcd48bab496cf20e3df"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a318b07d593f630c6918f9f0ad105bb3062bcdd026fe10f61c9fa0e59b83954"
    sha256 cellar: :any,                 arm64_sequoia: "96ea0db4727c8a45a5b0b9e28d5249ed186ae1c160b8bb2bc7a19f7815f766e7"
    sha256 cellar: :any,                 arm64_sonoma:  "d1f6ee793790a5634c481be34a5881ab75f50f9be683ac0e2d02e161515a7c68"
    sha256 cellar: :any,                 sonoma:        "4a975bd0c8e139a83f68c5a3c8c2d73bd38a2cd36debe496b3b81b5b6b5a0402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6316393a4b835b68727519334db79fd4d41796086276e166a7c7f7cabe5ab5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181d330da3f6d4f01d2e6fe2a787450243de84ed33c2689b9193da26740249c0"
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
