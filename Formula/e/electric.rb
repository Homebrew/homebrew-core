class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.1.11.tar.gz"
  sha256 "cb0857ea72fb271f935cf4360ffca1e1bc714ae646764ff86db44feea905dd42"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8da57d0828fb26fb905e9403508e42676811f60f378916df95641dcfe01399b7"
    sha256 cellar: :any,                 arm64_sequoia: "ab61e9537354788e61387ab579aec216c7bfcd718e68d71385bd7c512ead0b30"
    sha256 cellar: :any,                 arm64_sonoma:  "6d8c1c5936c0cf79b0f43af5addce2dbc8e3d61f74fe350fcebfb963f624d037"
    sha256 cellar: :any,                 arm64_ventura: "27df93896cbc5334c121ff77c668971687847f3ef9e1bbb65cd6bb59e016f132"
    sha256 cellar: :any,                 sonoma:        "dcaf55e06251824dc1431edb25bea1971b4667ad56d8eddc0ceda35de2f2d97a"
    sha256 cellar: :any,                 ventura:       "8a29e06a3feded8b7245c1eaa76b6cce5c7b9a411732bc2f76519d8174d59999"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79ac603d9802c669e181dedb6f89da19ba6142e2a6e48cf7f7b600c73ef1a74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4647fcb3331fba8c33403e8a64601652fe74f94aea4701a4cea148be46b31928"
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
