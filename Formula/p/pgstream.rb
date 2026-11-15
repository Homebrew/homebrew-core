class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "4b9cf2c14d4f448b265bddf259da1ae79da58099e8257670bd47f7d225a821dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5139df589f96fbe49a781be8b569d8c85a5df9c9e87dd10308ca12531a716c21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd224c8d9f73e2591b437eb30fe95bcb4ec7b29f9b5f43e5d5aa26268c48f357"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f3de6d813c30c44a5aaf8bc9f63a3636ca0f23e77c556638de0599f8e5ca262"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e843e6bc1732ed662ed6d9b439e58326cd152140f1d7418559b63d9b2eb10b1b"
    sha256 cellar: :any,                 x86_64_linux:      "67cfbf86f9c1128d3ba6d5f2ca90159c65ef0038e4b1cc78d8d83c58fde5c620"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "wal2json" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/xataio/pgstream/cmd.Version=#{version}"
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
      output_plugin_libraries = 'pgoutput, test_decoding, wal2json'
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
