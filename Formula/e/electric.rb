class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.2.7.tar.gz"
  sha256 "fd740868fc0a7ce314b0a900586c86ccd925ca424e63b1fff3d2ef747302faf1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b4d4f3c7aacea150bf736f8a11b97e2e81f28a18a15806f01910e4cc87cb4afc"
    sha256 cellar: :any,                 arm64_sequoia: "64910241d4b4db30f6a0f942201872d2e9ee5595e253a2c3986af543faf81c33"
    sha256 cellar: :any,                 arm64_sonoma:  "260510260af48b4b12352876969d7f6baf8bcfb24295cd79dff5d384d7b9e431"
    sha256 cellar: :any,                 sonoma:        "1d9dd2498679edd9c70fb452723b661da3717dc3267669cb4f32c3a963cbd61c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76f94c065d9feca30f82a91c68a4a7c7a6423c106efa5390d77fb4f0817cb184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "043c74c64ee06ecd14dd849be5b6ebae2212b25bac6115ea9d8a8401adaac083"
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
