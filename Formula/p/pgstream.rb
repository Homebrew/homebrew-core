class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "1212cad5c18a857db4449d4a7d740619c5e74cbc98c6f98aa6eb195aed231dc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1143ca9e88333ae0aaa9a023f610119a92343abb71ca10daee22aa10b534669"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab210737a475ff60142c9f0edd8468ad9e117685c9f138797202a6950dbebf1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25b03cfab3789be274d8c47224bc1c7cd9ab1be5718a046f87c369516accc4be"
    sha256 cellar: :any_skip_relocation, sonoma:        "fce07e158eef31ca4c6c64a66502b5a8d5bd8854890f4da1b306076b74848de4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4d21f19a45d4762221482dfa1c40af9ec2b86d08a39fcafe6413d7cb64b67df"
    sha256 cellar: :any,                 x86_64_linux:  "7d1c854872d1c503881df9e851f9ba6f97c445a6be57761ad8e7e50662e55021"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "wal2json" => :test

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
