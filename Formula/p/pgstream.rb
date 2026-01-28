class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "448a79be5691e462ec852ed0b654347ff2e477c7b6c1937f27a6cabae6d5f8f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d03b2ae807dc17a94aeacf9bad3028ebad3bedc113805bf806270f4123584bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d03b2ae807dc17a94aeacf9bad3028ebad3bedc113805bf806270f4123584bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d03b2ae807dc17a94aeacf9bad3028ebad3bedc113805bf806270f4123584bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf668b7b95e372c4536e39412eb397012ae2db7b2067d2aad97a38e37cbeb5a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e52616d9e5ff2912513255d56b090c2a565d6200c67a4ecbac2c7d307eea7c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcf8f96e77d55ce0bb5e2efa00dc262f236357207eb28abfafa69b0e764373d2"
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
