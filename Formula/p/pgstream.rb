class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "e9784944d8af23257f8fedc453949e59f4c2a27068fc52686fa3457e22d74411"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2173c709787ea6d70f22aa2a8cbdbc1752922ea71af76e67cb90bab8c976f641"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2173c709787ea6d70f22aa2a8cbdbc1752922ea71af76e67cb90bab8c976f641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2173c709787ea6d70f22aa2a8cbdbc1752922ea71af76e67cb90bab8c976f641"
    sha256 cellar: :any_skip_relocation, sonoma:        "354ad7185beaa932a4c761370b61214e3e3a90b7ffd6d1a9af7060e3a4a75c83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11f7796a8217af4e6c477eab7b4319e6ef07d5f5a0495e10c3f97f36fde5f2b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8518c53caff6b25301a1bd5479e4cc0b104c0c26e9e7a84c4e7c56ad730c6e88"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "wal2json" => :test

  def install
    ldflags = "-s -w -X github.com/xataio/pgstream/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pgstream", shell_parameter_format: :cobra)
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
