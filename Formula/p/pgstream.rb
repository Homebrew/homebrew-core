class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "2328fd33f99cf0d1ab6322f1e44dad1b2a14de1479c11a85ba04b4e5f7f4afed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44a99755475cfbb0137f25e203dfed538d799481ee3120e54c0fd0850b2ef69f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44a99755475cfbb0137f25e203dfed538d799481ee3120e54c0fd0850b2ef69f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44a99755475cfbb0137f25e203dfed538d799481ee3120e54c0fd0850b2ef69f"
    sha256 cellar: :any_skip_relocation, sonoma:        "133f74ebf9232f365ca5ca7f6b14c358ed75ce8b50196617e5b1a5c80ac3d9b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed7d6a04c7239c9560e26c61ec832a6b886f2ec99009eaecfaab619a9e92def1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc23c2915077d730a526d62c8856d657c42fc2a3fb6d750e81ceedb426e0182"
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
