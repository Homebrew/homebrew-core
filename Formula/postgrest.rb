require "language/haskell"
require "net/http"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/begriffs/postgrest"
  revision 2

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
    sha256 "ba54697c96d2c860b70cd4b741903321c3888b2fb7c1da5f8e9902d19c3c45cd" => :el_capitan
    sha256 "71b5b1555385bf22a7c1a48cf5a865afd9d9a10c6336b6e31bdeb0f78009b6c8" => :yosemite
    sha256 "442ed19e6f8a0f2655113d0470af713f5bbbe2a6ec040a1eca038bea66e47324" => :mavericks
  end

  head do
    url "https://github.com/begriffs/postgrest.git"

    # Equivalent to the patch :DATA for stable above
    patch do
      url "https://github.com/begriffs/postgrest/pull/619.patch"
      sha256 "e98e5bad88a62d33ab2a7dfda88c1b34315231d27179cc708b959468c1a20191"
    end
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "postgresql"

  # Upstream wai-cors commit removing the parsers dependency. Alternatively,
  # there is an upstream parsers patch that would work, but wai-cors is higher
  # up the dependency tree
  resource "wai-cors-remove-parsers-dep" do
    url "https://github.com/larskuhtz/wai-cors/commit/3f90298038ca391351f4c2d243db3114842f4bf3.patch"
    sha256 "10e6ff38ec2da94d359143ffdbcabe1fca127c26f2716e532459fb217dc0819e"
  end

  def install
    cabal_sandbox do
      buildpath.install resource("wai-cors-remove-parsers-dep")
      system "cabal", "get", "wai-cors"
      cd "wai-cors-0.2.4" do
        system "/usr/bin/patch", "-p1", "-i", buildpath/"3f90298038ca391351f4c2d243db3114842f4bf3.patch"
      end
      cabal_sandbox_add_source "wai-cors-0.2.4"

      system "cabal", "get", "jwt"
      # Equivalent to upstream jwt commit https://bitbucket.org/ssaasen/haskell-jwt/commits/2c48f81ed5d53af4d5d3ecf49f6e45adae61b348?at=master
      inreplace "jwt-0.7.1/jwt.cabal",
        "build-depends:       base >= 4.6 && < 4.9",
        "build-depends:       base >= 4.6 && < 5"
      cabal_sandbox_add_source "jwt-0.7.1"

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

__END__
diff --git a/postgrest.cabal b/postgrest.cabal
index 0b32e03..abcc078 100644
--- a/postgrest.cabal
+++ b/postgrest.cabal
@@ -29,6 +29,7 @@ executable postgrest
   build-depends:       aeson (>= 0.8 && < 0.10) || (>= 0.11 && < 0.12)
                      , base >= 4.8 && < 5
                      , bytestring
+                     , bytestring-tree-builder == 0.2.7
                      , case-insensitive
                      , cassava
                      , containers
@@ -36,7 +37,7 @@ executable postgrest
                      , errors
                      , hasql >= 0.19.9 && < 0.20
                      , hasql-pool >= 0.4 && < 0.5
-                     , hasql-transaction >= 0.4.3 && < 0.5
+                     , hasql-transaction == 0.4.5
                      , http-types
                      , interpolatedstring-perl6
                      , jwt
@@ -46,6 +47,7 @@ executable postgrest
                      , optparse-applicative >= 0.11 && < 0.13
                      , parsec
                      , postgrest
+                     , postgresql-binary == 0.9.0.1
                      , regex-tdfa
                      , safe >= 0.3 && < 0.4
                      , scientific
