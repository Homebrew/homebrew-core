class Pgroll < Formula
  desc "Postgres zero-downtime migrations made easy"
  homepage "https://pgroll.com"
  url "https://github.com/xataio/pgroll/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "d944b31c6a4b90eeb170db249c1a012b85663ff25f438f007068efc76e4546a7"
  license "Apache-2.0"
  head "https://github.com/xataio/pgroll.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cb3fa634ee1808834ddec42df102b893b6378cbee84570d00ff5107b8013fb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f72efb4b8a69f0d2aeb68a9c645052f4a6521cd19dff3c0728cfa319ee68c92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5f0cf02c11763791b45fab6e4dc3c951e16ecf9f96145e42659e3d6280b0291"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c13903e898977f1b471745cef114762c1bbc97041e77ad2f5888aab3aa234e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b68f49b0cbf7ebff66ff8ff108590d2bdada0d5a8b72e125bbf6dbe7d2a1c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "070c426e63b951f25aa8c46136e8f5abc971f849b0800c828ef2c59a6ce5b7e3"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test
  depends_on "libpg_query"

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = "-s -w -X github.com/xataio/pgroll/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pgroll", shell_parameter_format: :cobra)

    pkgshare.install "examples/01_create_tables.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgroll --version")

    cp_r pkgshare/"01_create_tables.yaml", testpath
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      pg_uri = "postgres://#{ENV["USER"]}@localhost:#{port}/postgres?sslmode=disable"

      system bin/"pgroll", "init", "--postgres-url", pg_uri
      system bin/"pgroll", "--postgres-url", pg_uri, "start", "01_create_tables.yaml"

      status_output = shell_output("#{bin}/pgroll --postgres-url #{pg_uri} status")
      assert_match "01_create_tables", status_output

      complete_output = shell_output("#{bin}/pgroll --postgres-url #{pg_uri} complete 2>&1")
      assert_match "Migration successful", complete_output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
