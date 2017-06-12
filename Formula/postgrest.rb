require "language/haskell"
require "net/http"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/begriffs/postgrest"
  url "https://github.com/begriffs/postgrest/archive/v0.4.2.0.tar.gz"
  sha256 "9337d8f623a748d789d9a580fb5e5538e225b654eaaad94d5eac8df2cdeaeb5e"
  head "https://github.com/begriffs/postgrest.git"

  bottle do
    sha256 "8e5302c9b9a0f05c13ab79a1eadce2d1f2b9f377a62b33fb9abbda967c9d9794" => :sierra
    sha256 "fd4129796888fb94801a5abb580dc57f3bcfd0f2edb00eeea20bbf83137eb34d" => :el_capitan
    sha256 "93b8f4c8cba07814162214dfdc665befc8629cd4f0505290dcc085a23dde5ae8" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "postgresql"

  def install
    # Workaround for "error: redefinition of enumerator '_CLOCK_REALTIME'" and
    # other similar errors.
    # Reported 11 Jun 2017 https://github.com/haskell-foundation/foundation/issues/342
    if MacOS.version == :el_capitan
      install_cabal_package "--constraint", "foundation < 0.0.10", :using => ["happy"]
    else
      install_cabal_package :using => ["happy"]
    end
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
      (testpath/"postgrest.config").write <<-EOS.undent
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
