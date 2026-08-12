class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "67c4d0d10026ce99e4c236e0d27317842edb809b9fd1cc54183eed0aa1e97084"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "994748ba6b5dc0dc15700f9f42f1a9e78ed05ea864a1ab7885cb089bf9565cc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eab70b6c6bc1f2e54801850dd2ec4776ab2aaea0479c1b653a635bc5606c1ca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eab665465269c805bf68457b4bea5c4d2bba5847d118903316b03802f89f2b72"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1576a776c8865cc4c88baf1968c0096f0c3beb91eb0263c650d087897f68091"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e549366c2627bddbf26649907ae75223532266b61853a08cc5870680efae2ee"
    sha256 cellar: :any,                 x86_64_linux:  "e90cc7bdc25249a91743af31d8824858d064ca3c93a0aa4b0b2606c9827492d4"
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
