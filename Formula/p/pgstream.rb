class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "330a1601722c11bc5851df097ab901c4c72d8f3350be2c0272edf5fbd8e05e87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "879971f4e0b6b26b40b56230f01be59427d2b3db377042c94f032b2577e6601b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "879971f4e0b6b26b40b56230f01be59427d2b3db377042c94f032b2577e6601b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "879971f4e0b6b26b40b56230f01be59427d2b3db377042c94f032b2577e6601b"
    sha256 cellar: :any_skip_relocation, sonoma:        "42383fa97b55cbdff1edb9a1ccc80e97d6c0f64526f322a42316b8e272735698"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9be5ed041995bb5b91de46ed13db4cac83b7054ccfba5391584f5ab5c640bf7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a0cd97a8e3de921dde13032de6857fc133040c27a467d70813cd924ff8d37e"
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
