class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/database/technologies/related/berkeleydb.html"
  url "https://download.oracle.com/berkeley-db/db-18.1.40.tar.gz"
  mirror "https://fossies.org/linux/misc/db-18.1.40.tar.gz"
  sha256 "0cecb2ef0c67b166de93732769abdeba0555086d51de1090df325e18ee8da9c8"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.oracle.com/database/technologies/related/berkeleydb-downloads.html"
    regex(%r{href=.*?/berkeley-db/db[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "676c2b4f7fc4d0e988f04f3c8474b8bd962979ad6fd93720dc5b200674dc6239"
    sha256 cellar: :any,                 arm64_big_sur:  "fb300ebe3dcc5b308c6fbc383856545a6b35e883889c95f0bfeee40d6d07b02d"
    sha256 cellar: :any,                 monterey:       "5193fb2dfd137612487dd3d1644151c342db13760f64bd5913a964efb502f7ab"
    sha256 cellar: :any,                 big_sur:        "dc8c2c76f315ea02737e9277f74cc9f8faba1733c10c20e2ef62d50b4abce4b7"
    sha256 cellar: :any,                 catalina:       "f4d82916099a1023af6a72675dce0a445000efd2286866d1f36bf0b1063b24aa"
    sha256 cellar: :any,                 mojave:         "ef85a6b6fb93f8dcee4144acf22665a331c5b2398822a5f183aed0fb863718f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f33ddf91965070b68d81c110cda45797bfd5e75f1e23d90f4b66497335833dc"
  end

  depends_on "openssl@1.1"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    directory "dist"
  end

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
