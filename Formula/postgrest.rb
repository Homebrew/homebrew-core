class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v7.0.1.tar.gz"
  sha256 "12f621065b17934c474c85f91ad7b276bff46f684a5f49795b10b39eaacfdcaa"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git"

  bottle do
    cellar :any
    sha256 "bb885e5c86b0e997b660b0ab3975d59c458f0db4436bce9ea158b89c65dcd6e2" => :big_sur
    sha256 "691546e89701fd582d47c697dc27551ef3284ee21933a5912f406e6fee4dd272" => :catalina
    sha256 "34c0413e71a41bc8550b7ea5286e0330aa888990d2e2a8fe6d81b57152c83d61" => :mojave
    sha256 "6ca3bb9cd14c9ab4ddd028493e4ffd70ddae571be74723997b677c6c67542c87" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "postgresql"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    return if ENV["CI"]

    pg_bin  = Formula["postgresql"].bin
    pg_port = free_port
    pg_user = "postgrest_test_user"
    test_db = "test_postgrest_formula"

    system "#{pg_bin}/initdb", "-D", testpath/test_db,
      "--auth=trust", "--username=#{pg_user}"

    system "#{pg_bin}/pg_ctl", "-D", testpath/test_db, "-l",
      testpath/"#{test_db}.log", "-w", "-o", %Q("-p #{pg_port}"), "start"

    begin
      port = free_port
      system "#{pg_bin}/createdb", "-w", "-p", pg_port, "-U", pg_user, test_db
      (testpath/"postgrest.config").write <<~EOS
        db-uri = "postgres://#{pg_user}@localhost:#{pg_port}/#{test_db}"
        db-schema = "public"
        db-anon-role = "#{pg_user}"
        server-port = #{port}
      EOS
      pid = fork do
        exec "#{bin}/postgrest", "postgrest.config"
      end
      sleep 5 # Wait for the server to start

      output = shell_output("curl -s http://localhost:#{port}")
      assert_match "200", output
    ensure
      begin
        Process.kill("TERM", pid) if pid
      ensure
        system "#{pg_bin}/pg_ctl", "-D", testpath/test_db, "stop",
          "-s", "-m", "fast"
      end
    end
  end
end
