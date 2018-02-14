class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/technology/products/berkeley-db/index.html"
  url "https://download.oracle.com/berkeley-db/db-6.2.32.tar.gz"
  sha256 "a9c5e2b004a5777aa03510cfe5cd766a4a3b777713406b02809c17c8e0e7a8fb"

  bottle do
    cellar :any
    sha256 "ee2f38644137df02f3ebd9fa689a09f1e12c2a21dab38a03f77e2c213a6135ef" => :high_sierra
    sha256 "eb54f8ab1d0149e073f641ad066e6ffb179afdee83cd3211e90eeaaaa4a7bc9a" => :sierra
    sha256 "c084857cfdd9bbc5eec028cc551d2323c050489e8a963ec40076270db8d14fb3" => :el_capitan
    sha256 "1ed9a471cd8a38b58053a86e37b4ec83c09944781158fa20e2ba300f3b374f4f" => :yosemite
  end

  depends_on :java => [:optional, :build]

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
