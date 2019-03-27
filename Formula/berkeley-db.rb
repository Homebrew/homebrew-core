class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/technology/products/berkeley-db/index.html"
  # Requires registration to download so we mirror it
  url "https://dl.bintray.com/homebrew/mirror/berkeley-db-18.1.32.tar.gz"
  mirror "https://fossies.org/linux/misc/db-18.1.32.tar.gz"
  sha256 "fa1fe7de9ba91ad472c25d026f931802597c29f28ae951960685cde487c8d654"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cbaa8655a8a17e46c385b9d81a610ad5f50a9a04018c6f7f3642ef1337276b22" => :mojave
    sha256 "b08ec41ebbd72ae0428f32406a412b6172fc3a6ca6e72290da68d4e6df03c3a5" => :high_sierra
    sha256 "6132986c6b08b8143b776f80f29ba02dfb5502e48cc0689a5c924c5e6de5c488" => :sierra
  end

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
