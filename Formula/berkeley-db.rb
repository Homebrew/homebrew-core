class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/technology/products/berkeley-db/index.html"
  # Requires registration to download so we mirror it
  url "https://dl.bintray.com/homebrew/mirror/berkeley-db-18.1.32.tar.gz"
  mirror "https://fossies.org/linux/misc/db-18.1.32.tar.gz"
  sha256 "fa1fe7de9ba91ad472c25d026f931802597c29f28ae951960685cde487c8d654"
  revision 1

  bottle do
    cellar :any
    sha256 "eb5d0a59cec0fab48a0539f96195b1890599603577ca1792f831085418b19707" => :mojave
    sha256 "fa53aeeca3bef551d9f604b5eafb6b94bf1f14b95530a8d16e243fb7c2ad790e" => :high_sierra
    sha256 "1b3c06f6d3b1f45180068cb7127508072ed661e981e922dd273d6faef0030bc1" => :sierra
  end

  depends_on "openssl@1.1"

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
