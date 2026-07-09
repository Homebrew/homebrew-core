class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "6bfa9df8cd7ea25eb560042548082c01d08c1fb33d9588c21b77ccf8ff949895"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f869627dbc4ee2c4d58adb8415a1f581bdca552b5b05bc22d85a61de8792cb97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "152a347352f62fd1d2224595bb79ec857432f8d778069113a2853664dbeb5d90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08466f1db10ca67b83e1adeebb655551078ba940c6b4c596965173aaff7daa23"
    sha256 cellar: :any_skip_relocation, sonoma:        "295ae129a2b5b57b62b863734018b34ca98e6cee374d3d8043b6cf8ecbd23dee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a83dda592871f6fc98fd2a367e73da40d7c45ba29a4acda10e034c9a48a6bdbf"
    sha256 cellar: :any,                 x86_64_linux:  "d85ea65b4179a62c13e9556fcf34a0e91374410563d2da3aa281d5c6519bfb6e"
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
