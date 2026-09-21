class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "910256b63eb68266cb734a1f5ef4ec253b51ecfd90d88d7c44daa225d8c361a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f5ad7a95f97a6a8bc76a1a1290dd1bf38617c0bf008e5db351f57ce39d39b9f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9feb18bec493991c30b54c6ad53ffbe648db0b8e75fd4e7b3a8b1701b64e0ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6439dc153da97921a8c910cf8d5195b7aec0a7f94c0cd00fc6ba451a527c380"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "33383e50e514ec5fb9ba285df849683abf177f7dd1b57e3896912afba311cc1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4f655a9bb2dc420a01654b32603d3bd5fedaf2287ea05b3ba063b031875224fb"
    sha256 cellar: :any,                 x86_64_linux:      "d25873b1cfabb654f45264bddcbe04399edc2edc3f924e8a2cd7968b477b8e5a"
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
