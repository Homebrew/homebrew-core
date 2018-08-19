class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/technology/products/berkeley-db/index.html"
  # Requires registration to download so we mirror it
  url "https://dl.bintray.com/homebrew/mirror/berkeley-db-18.1.25.tar.gz"
  sha256 "2ea8b8bc0611d9b4c2b9fee84a4a312dddfec007067af6e02ed46a26354181bb"

  bottle do
    cellar :any
    sha256 "033c836af359a4169a73b7778b837814d0df74fa514e5dd01efdc0b2272e830f" => :mojave
    sha256 "b3ee1f3ef01f18bb4c958cac6b84b593718d9fb8e43cf480abd44dad2c6a1c8a" => :high_sierra
    sha256 "95ffd72a00ed6faa8131b13482dd4592311410f8d4010934949b43b7a273c03e" => :sierra
    sha256 "12b3dcf8c9549ee7a6afdafbc0ff7235fe069af06a28d26525e57b8f8ae37a61" => :el_capitan
  end

  depends_on :java => [:optional, :build]
  depends_on "openssl"

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    # --enable-compat185 is necessary because our build shadows
    # the system berkeley db 1.x
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-cxx
      --enable-compat185
      --enable-sql
      --enable-sql_codegen
      --enable-dbm
      --enable-stl
    ]
    args << "--enable-java" if build.with? "java"

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd "build_unix" do
      system "../dist/configure", *args
      system "make", "install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix/"docs", doc
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
