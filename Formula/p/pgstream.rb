class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "8800a4889fd8d062a45117bbc57434bb46d873e3c7db631520a4373c5d1c3684"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "712249f75dfbe96ad904a53441e9ef32907dd0f21d26a096996731c7dcfbae15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "712249f75dfbe96ad904a53441e9ef32907dd0f21d26a096996731c7dcfbae15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "712249f75dfbe96ad904a53441e9ef32907dd0f21d26a096996731c7dcfbae15"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a59feaeedaf5d7f2b5a6210065f0915a27ad5ffb89af35f0213490b2a1b70ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ee451e366e111df4cd6640015088caa29e6f28f5cf6f490f02e0b6c845ed30c"
    sha256 cellar: :any,                 x86_64_linux:  "e88c0836a5e76017e51aabfc6d78090ac7e3234e74b93d534723fca8bc4d8dca"
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
    (testpath/"test/postgresql.conf").write <<~CONF, mode: "a+"
      port = #{port}
      shared_preload_libraries = 'wal2json'
      wal_level = logical
    CONF
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      url = "postgres://localhost:#{port}/postgres?sslmode=disable"
      system bin/"pgstream", "init", "--postgres-url", url
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
