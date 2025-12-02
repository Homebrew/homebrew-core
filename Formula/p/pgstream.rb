class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "62a645a39b3685873839a40630533bcadb6bd6016098fbedfb65698ec874b5bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7252f21bb6e792eb1d0eafeb56eade1705166bd2029d79e11587d0a42589141"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7252f21bb6e792eb1d0eafeb56eade1705166bd2029d79e11587d0a42589141"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7252f21bb6e792eb1d0eafeb56eade1705166bd2029d79e11587d0a42589141"
    sha256 cellar: :any_skip_relocation, sonoma:        "a476c2df43280dbd5d435d3804b2f240132a8d74b5bdf7efebfc3d4f5753e8af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84e31dde7f21a19129f2a398fe90dc37386c633dc961820ba98eabfc3daf58c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6e16de16814cbb2ead4060ec850cf28cad5bab27cc8ba94b167a69f2e0ac29b"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "wal2json" => :test

  def install
    ldflags = "-s -w -X github.com/xataio/pgstream/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgstream --version")

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
      shared_preload_libraries = 'wal2json'
      wal_level = logical
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      url = "postgres://localhost:#{port}/postgres?sslmode=disable"
      system bin/"pgstream", "init", "--postgres-url", url
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
