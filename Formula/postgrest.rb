require "language/haskell"
require "net/http"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/begriffs/postgrest"
  url "https://github.com/begriffs/postgrest/archive/v0.3.1.1.tar.gz"
  sha256 "1830900175879d4be40b93410a7617cb637aae7e9e70792bf70e2bf72b0b2150"
  revision 1

  bottle do
    revision 1
    sha256 "f550103a55394e57ba1cd4a1b9d7923eb9901bc0161094c5444fb90060938423" => :el_capitan
    sha256 "9d11521d1aed51d44559867973ccb65c08b2ec76533c5442f9df7338967bae4d" => :yosemite
    sha256 "553d1d07e2bbf9b17b35eecc3ab26c47abfa768d9e9180741f694b5f392342bf" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "postgresql"

  def install
    # GHC 8 compat
    # Reported 26 May 2016: https://github.com/begriffs/postgrest/issues/612
    cabalcfg = "allow-newer: base,transformers"
    cabalcfg << "\nconstraints:"
    cabal_sandbox do
      %w[
        bytestring-tree-builder 0.2.6
        postgresql-binary 0.9
        hasql-transaction 0.4.4.1
      ].each_slice(2) do |pkg, ver|
        cabalcfg << "\n#{pkg} ==#{ver}"
        system "cabal", "get", pkg
        cabal_sandbox_add_source "#{pkg}-#{ver}"
        inreplace "#{pkg}-#{ver}/#{pkg}.cabal" do |s|
          if pkg == "hasql-transaction"
            s.gsub! "build-depends:", "build-depends: base,"
          else
            s.gsub! "ghc-options:", "ghc-options: -XNoImpredicativeTypes"
          end
        end
      end
      (buildpath/"cabal.config").write(cabalcfg)

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
