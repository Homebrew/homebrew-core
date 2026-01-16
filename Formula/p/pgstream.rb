class Pgstream < Formula
  desc "PostgreSQL replication with DDL changes"
  homepage "https://github.com/xataio/pgstream"
  url "https://github.com/xataio/pgstream/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "09cbfaaa477c9c5d73df4ab3ebbb8d9e31497e0bbcf1ff51f3347c68be20fdab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f6ca5ee8c99d688f91f3dd398caf1f9bbe050e7056d81f7887a5d70669a53c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f6ca5ee8c99d688f91f3dd398caf1f9bbe050e7056d81f7887a5d70669a53c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f6ca5ee8c99d688f91f3dd398caf1f9bbe050e7056d81f7887a5d70669a53c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3a06cfbb546158fdfb86d3b445629e81d84d89269b262fd74b9b60952826e8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b9fbe7fc41df2b6579d35624a58a0b61c1eabc2269367532a5c708df08496c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4adb8553d83de3401509d70f228eb50a9da2cc3e98eba43602a15cd57381ca49"
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
