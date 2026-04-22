class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "330a1601722c11bc5851df097ab901c4c72d8f3350be2c0272edf5fbd8e05e87"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3e4f5b593556edbb40dfcc90ecde3df1495c0e74cb85f561c0114d239c746d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3e4f5b593556edbb40dfcc90ecde3df1495c0e74cb85f561c0114d239c746d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3e4f5b593556edbb40dfcc90ecde3df1495c0e74cb85f561c0114d239c746d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8574a2194f1914bb1a05f0b12a70c2c967a249387c5e1d4b409c9c828aa1c5bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ba3e4464b803af28dd02061ddc1cbacf75222dab31c348838a9a02dc4ca9cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b374394b5710faffeef8f70e46e8cc0bbd8b23566bf3715a9814ac1eea8962f"
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
