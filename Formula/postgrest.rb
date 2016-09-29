require "language/haskell"
require "net/http"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/begriffs/postgrest"
  url "https://github.com/begriffs/postgrest/archive/v0.3.2.0.tar.gz"
  sha256 "1cedceb22f051d4d80a75e4ac7a875164e3ee15bd6f6edc68dfca7c9265a2481"
  revision 1
  head "https://github.com/begriffs/postgrest.git"

  bottle do
    sha256 "889e4eba9ec555d6304765feb5e25cd46d55806a323e237f4fba708a55af8dad" => :sierra
    sha256 "a6315f312795298dca7bb58b8b671020e52db78f7f60c85a80647f2af0ef5ba5" => :el_capitan
    sha256 "f775adbb96f422903e41af81d5277dcbd6497197308fe26abce04e574d7778d1" => :yosemite
    sha256 "f245755397ec6c1718f989f3df8cb6a5b0e6d3ae821304954d51c22050f58e6e" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "postgresql"

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    pg_bin  = Formula["postgresql"].bin
    pg_port = 55561
    pg_user = "postgrest_test_user"
    test_db = "test_postgrest_formula"

    system "#{pg_bin}/initdb", "-D", testpath/test_db,
      "--auth=trust", "--username=#{pg_user}"

    system "#{pg_bin}/pg_ctl", "-D", testpath/test_db, "-l",
      testpath/"#{test_db}.log", "-w", "-o", %("-p #{pg_port}"), "start"

    begin
      system "#{pg_bin}/createdb", "-w", "-p", pg_port, "-U", pg_user, test_db
      pid = fork do
        exec "postgrest", "postgres://#{pg_user}@localhost:#{pg_port}/#{test_db}",
          "-a", pg_user, "-p", "55560"
      end
      Process.detach(pid)
      sleep(5) # Wait for the server to start
      response = Net::HTTP.get(URI("http://localhost:55560"))
      assert_equal "[]", response
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
