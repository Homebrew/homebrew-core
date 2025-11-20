class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v0.8.10.tar.gz"
  sha256 "38634a9fb479c6dcd1bad9ee5f8910c1db5383c2482d5edc838d556ca6a807ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd7a46d346294afded76a78aee13496390198f5e46e976db1ec79588cb63630b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd7a46d346294afded76a78aee13496390198f5e46e976db1ec79588cb63630b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd7a46d346294afded76a78aee13496390198f5e46e976db1ec79588cb63630b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbf04aafc5f6ba58df25406e8f00bf503190d179663e41937907eda51166af31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38cbc04eb6ed8dd4ed25bac09cd86245a904213d4bf4c78e19010d8c4243345d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5673168f45dd67249ad82257d43571884a61c82d1da8e05c173f82ad6c80dcd"
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
