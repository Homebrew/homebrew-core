require "language/haskell"
require "net/http"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/begriffs/postgrest"
  revision 3
  head "https://github.com/begriffs/postgrest.git"

  stable do
    url "https://github.com/begriffs/postgrest/archive/v0.3.1.1.tar.gz"
    sha256 "1830900175879d4be40b93410a7617cb637aae7e9e70792bf70e2bf72b0b2150"

    # Upstream postgrest PR bumping the constraints for bytestring-tree-builder,
    # hasql-transaction, and postgresql-binary, so that we no longer have to
    # patch any of those; https://github.com/begriffs/postgrest/pull/619 doesn't
    # apply cleanly to the tagged release, so using an equivalent patch :DATA
    patch :DATA
  end

  bottle do
    sha256 "3e1e6f8ba867ea149374b712c75a97cee87281ef2cb1c96c780efc59dbf6f5fb" => :el_capitan
    sha256 "b8b506f74214d00cf4741a1ec65651a9cc6fa88d5156e2f9aa97caab60c57deb" => :yosemite
    sha256 "e2d4bc81c1d9dfd43d11b57bc7224684f0d60f89737041b2fdc74f27cb3ae78c" => :mavericks
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

__END__
diff --git a/postgrest.cabal b/postgrest.cabal
index 0b32e03..ff5e7c4 100644
--- a/postgrest.cabal
+++ b/postgrest.cabal
@@ -27,16 +27,17 @@ executable postgrest
   ghc-options:         -threaded -rtsopts -with-rtsopts=-N
   default-language:    Haskell2010
   build-depends:       aeson (>= 0.8 && < 0.10) || (>= 0.11 && < 0.12)
-                     , base >= 4.8 && < 5
+                     , base >= 4.8 && < 6
                      , bytestring
+                     , bytestring-tree-builder == 0.2.7
                      , case-insensitive
                      , cassava
                      , containers
                      , contravariant
                      , errors
-                     , hasql >= 0.19.9 && < 0.20
-                     , hasql-pool >= 0.4 && < 0.5
-                     , hasql-transaction >= 0.4.3 && < 0.5
+                     , hasql == 0.19.12
+                     , hasql-pool == 0.4.1
+                     , hasql-transaction == 0.4.5
                      , http-types
                      , interpolatedstring-perl6
                      , jwt
@@ -45,6 +46,7 @@ executable postgrest
                      , mtl
                      , optparse-applicative >= 0.11 && < 0.13
                      , parsec
+                     , postgresql-binary == 0.9.0.1
                      , postgrest
                      , regex-tdfa
                      , safe >= 0.3 && < 0.4
@@ -82,7 +84,7 @@ library
   default-language:    Haskell2010
   default-extensions:  OverloadedStrings, ScopedTypeVariables, QuasiQuotes
   build-depends:       aeson
-                     , base >=4.6 && <5
+                     , base
                      , bytestring
                      , case-insensitive
                      , cassava
@@ -175,7 +177,7 @@ Test-Suite spec
                      , hasql-pool
                      , hasql-transaction
                      , heredoc
-                     , hspec == 2.2.*
+                     , hspec
                      , hspec-wai
                      , hspec-wai-json
                      , http-types
