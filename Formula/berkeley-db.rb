class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/technology/products/berkeley-db/index.html"
  # Requires registration to download so we mirror it
  url "https://dl.bintray.com/homebrew/mirror/berkeley-db-18.1.40.tar.gz"
  mirror "https://fossies.org/linux/misc/db-18.1.40.tar.gz"
  sha256 "0cecb2ef0c67b166de93732769abdeba0555086d51de1090df325e18ee8da9c8"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.oracle.com/technetwork/database/" \
    "database-technologies/berkeleydb/downloads/index.html"
    regex(%r{href=.*?/berkeley-db/db[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "069db18392eb453adbf6862ff6ab7c694fba8a0885c432a4c9c63ef2946d73a4"
    sha256 cellar: :any, big_sur:       "223eb7fbe303293676740e34fb6ff3f494ce17cba44029fb7ca47d64e138098f"
    sha256 cellar: :any, catalina:      "f2fc006ecf0cddfeaf94af43572ca4cebc6654d8a87f3ebfdb55329174596887"
    sha256 cellar: :any, mojave:        "eb5d0a59cec0fab48a0539f96195b1890599603577ca1792f831085418b19707"
    sha256 cellar: :any, high_sierra:   "fa53aeeca3bef551d9f604b5eafb6b94bf1f14b95530a8d16e243fb7c2ad790e"
    sha256 cellar: :any, sierra:        "1b3c06f6d3b1f45180068cb7127508072ed661e981e922dd273d6faef0030bc1"
  end

  depends_on "openssl@1.1"

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize

    # --enable-compat185 is necessary because our build shadows
    # the system berkeley db 1.x
    args = %W[
      --disable-debug
      --disable-static
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-cxx
      --enable-compat185
      --enable-sql
      --enable-sql_codegen
      --enable-dbm
      --enable-stl
    ]

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd "build_unix" do
      system "../dist/configure", *args
      system "make", "install", "DOCLIST=license"

      # delete docs dir because it is huge
      rm_rf prefix/"docs"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <assert.h>
      #include <string.h>
      #include <db_cxx.h>
      int main() {
        Db db(NULL, 0);
        assert(db.open(NULL, "test.db", NULL, DB_BTREE, DB_CREATE, 0) == 0);

        const char *project = "Homebrew";
        const char *stored_description = "The missing package manager for macOS";
        Dbt key(const_cast<char *>(project), strlen(project) + 1);
        Dbt stored_data(const_cast<char *>(stored_description), strlen(stored_description) + 1);
        assert(db.put(NULL, &key, &stored_data, DB_NOOVERWRITE) == 0);

        Dbt returned_data;
        assert(db.get(NULL, &key, &returned_data, 0) == 0);
        assert(strcmp(stored_description, (const char *)(returned_data.get_data())) == 0);

        assert(db.close(0) == 0);
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -ldb_cxx
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
    assert_predicate testpath/"test.db", :exist?
  end
end
