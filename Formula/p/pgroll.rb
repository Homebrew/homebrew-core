class Pgroll < Formula
  desc "Postgres zero-downtime migrations made easy"
  homepage "https://pgroll.com"
  url "https://github.com/xataio/pgroll/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "10130a21ec97eed79e2adfc933e4652932694d06cef5d4aace6f04a3461a924e"
  license "Apache-2.0"
  head "https://github.com/xataio/pgroll.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "613fa928565d4ed0c5d4d0811f2b5d216eda6bb51c7ffdc0289115d6b94c2dcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4b0d954f87a75ea80ff468b13a95ca0c2fb32b461cb4fe87fb3fc0e1dec5d7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9971a6553c2f17e889a1ca1ed0fb319c039e9acc125ad2ac9c6d9908f54c5467"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbd5116889f85fdd4faf7af01310926f662ba86127cc3025354d07d778adffb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7070edf104264980fa5cc5269e4d9ed6eef503d5fd3e8cf7836a080685ec555b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c01a2858ba6cb267d8e9f2d318d6f300d1db8cf7fe115a8b205d3e31d529a156"
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
