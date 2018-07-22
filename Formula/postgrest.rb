require "language/haskell"
require "net/http"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v0.5.0.0.tar.gz"
  sha256 "cfc9a6477d0f087051f654a0a7070804db388ed3c97e4e68d7d286e82d5be4b8"
  head "https://github.com/PostgREST/postgrest.git"

  bottle do
    cellar :any
    sha256 "ea1508ab22eaffe64955cbdd76647854e289d9ed3b6172e0fdd1a220fe2e6815" => :high_sierra
    sha256 "fba956125442f3db5548fce364269c98b599ed5c762992941c4461c9c60ca693" => :sierra
    sha256 "bfea24b8036f2bd5a81271cada5248f96ff0bc8ecf88492b4240cf77187b99e2" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build
  depends_on "postgresql"

  # Fix build failure with protolude 0.2.2 and hasql-transaction 0.6
  # Upstream PR 14 May 2018 "postgrest.cabal: fix constraints on protolude and
  # hasql-transaction"
  patch do
    url "https://github.com/PostgREST/postgrest/pull/1111.patch?full_index=1"
    sha256 "c740da96fb0dfb4a920d9f5091ec34fafcf9d8fe53b4eadda3cbdc80b02d09cd"
  end

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
      testpath/"#{test_db}.log", "-w", "-o", %Q("-p #{pg_port}"), "start"

    begin
      system "#{pg_bin}/createdb", "-w", "-p", pg_port, "-U", pg_user, test_db
      (testpath/"postgrest.config").write <<~EOS
        db-uri = "postgres://#{pg_user}@localhost:#{pg_port}/#{test_db}"
        db-schema = "public"
        db-anon-role = "#{pg_user}"
        server-port = 55560
      EOS
      pid = fork do
        exec "#{bin}/postgrest", "postgrest.config"
      end
      Process.detach(pid)
      sleep(5) # Wait for the server to start
      response = Net::HTTP.get(URI("http://localhost:55560"))
      assert_match /responses.*200.*OK/, response
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
