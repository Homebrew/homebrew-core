class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "3a69f7b42d188df01243bae6bcd1a6f05c9fda860ad2b711bd7624f7c74d7c52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95946a3526e6251f6651ce5cb832b62aa656f72dc178677ec457a1f6ebf4f57e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95946a3526e6251f6651ce5cb832b62aa656f72dc178677ec457a1f6ebf4f57e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95946a3526e6251f6651ce5cb832b62aa656f72dc178677ec457a1f6ebf4f57e"
    sha256 cellar: :any_skip_relocation, sonoma:        "168246a74a19417fab36371d8783f7bc3e110dc8263d616a757e5082d7a06ea8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbe9f6f1e553eed56a423cddd5f51dc471c7b2df1e8369bd5f27f2d5c1e879ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "544424f595746b673a96b1a60684eced9bed5ce61e6de3edfd43e2c58f246f44"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "wal2json" => :test

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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
