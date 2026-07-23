class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "2280a1b3e2da31945e4b569ae155257a424bbb1bc6e65a96643a974821a12cd0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13d1e386aa1b5d9de6c0328eaf3da312ed794d65c2d665026fbe9a39fa0e80e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13d1e386aa1b5d9de6c0328eaf3da312ed794d65c2d665026fbe9a39fa0e80e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13d1e386aa1b5d9de6c0328eaf3da312ed794d65c2d665026fbe9a39fa0e80e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7d0112206f7a680b2c62f47516c20571cddbbde667e9b463eb5b0e12ade8814"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "660cbc0beacd174b249e34f31900ca4c97e5fbdb64dd1ee5aed7749d128f606d"
    sha256 cellar: :any,                 x86_64_linux:  "3bdffdb6e6134b7996a7fb54d461362f163f2dcbf6c27d4d816896878a792a4b"
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
