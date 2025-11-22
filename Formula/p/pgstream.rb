class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "8701243d3ea0a78d30a94f2c5e07c416c4f3b8100b30442d906e6892f1a04186"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c79007aaabeffe407b2b7c1a9cf5b92dc0591da8f73249258a88300d70a1624"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c79007aaabeffe407b2b7c1a9cf5b92dc0591da8f73249258a88300d70a1624"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c79007aaabeffe407b2b7c1a9cf5b92dc0591da8f73249258a88300d70a1624"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f060565832c6ec39386241ad8034feeba0038ea86ef4cd377eb9d96be4515fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1d92efdd38e6d60088fe5a179647aa8d84a6e7218f4ff58b3f81d45badcdac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b7da31e47547099eec4499b52b40f11595cdc9b1c33e81dc129b619e1881efd"
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
