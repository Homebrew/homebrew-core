class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/technology/products/berkeley-db/index.html"
  url "http://download.oracle.com/berkeley-db/db-6.2.23.tar.gz"
  sha256 "47612c8991aa9ac2f6be721267c8d3cdccf5ac83105df8e50809daea24e95dc7"

  bottle do
    cellar :any
    sha256 "9aeac35b89e11e5b1eec4e5f17534523b64e05117471cb2121a58ca0f3bda5db" => :sierra
    sha256 "70f4c1cea6a4c2f9454680988b73bb9fdc107307dafeec47e21a4539dce57b36" => :el_capitan
    sha256 "3e4324500931e32e3a187f9790b4465efd4d249dc9ec03ff46b4209ed061e935" => :yosemite
    sha256 "b2ba3aff83ee27a52115f47abc3c1767d124841ad342e63e433dfa36af064b36" => :mavericks
    sha256 "8f5a87bc3336e01f8528ae8aaae24c83e8fa10e8f01ee65e8cac4af7d0786bf1" => :mountain_lion
  end

  option "without-sql", "Build without SQL support."
  option "without-dbm", "Build without dbm interface."

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
    ]
    args << "--enable-java" if build.with? "java"
    args << "--enable-sql" if build.with? "sql"
    args << "--enable-dbm" if build.with? "dbm"

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
    (testpath/"test.cpp").write <<-EOS.undent
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
    assert (testpath/"test.db").exist?
  end
end
