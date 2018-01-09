require "language/haskell"
require "net/http"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/begriffs/postgrest"
  url "https://github.com/begriffs/postgrest/archive/v0.4.4.0.tar.gz"
  sha256 "063eb700dc5c85a7916fc51d52c36ca2ae1d2dc326e1bc3211ec143bdaf66bf5"
  head "https://github.com/begriffs/postgrest.git"

  bottle do
    cellar :any
    sha256 "5bd9f1127627baeb7bf3cac278103cb6b63256af39fd7bdcc5a7550e64161aaf" => :high_sierra
    sha256 "42fdf57147e9a959beaab758900462739e9470351b5a11055af00bbe18e03609" => :sierra
    sha256 "d82e9e4ae9aeebfd7960596ad9ccd4bc3bc4547f57f0473aa3110f9dd52d2df0" => :el_capitan
    sha256 "8a209377bc643030baded9368b7004238f5ce22fd4f75e69546ce611eb1c9873" => :yosemite
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
