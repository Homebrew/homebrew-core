class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/database/technologies/related/berkeleydb.html"
  url "https://download.oracle.com/berkeley-db/db-18.1.40.tar.gz"
  mirror "https://fossies.org/linux/misc/db-18.1.40.tar.gz"
  sha256 "0cecb2ef0c67b166de93732769abdeba0555086d51de1090df325e18ee8da9c8"
  license "AGPL-3.0-only"
  revision 1

  livecheck do
    url "https://www.oracle.com/database/technologies/related/berkeleydb-downloads.html"
    regex(/Berkeley\s*DB[^(]*?\(\s*v?(\d+(?:\.\d+)+)\s*\)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9f95fac93b53a02ecf42f3abf60c5657f74aea8fccd7b8077c1b567a959bf750"
    sha256 cellar: :any,                 arm64_monterey: "8da7ddbf86ba57c94235796b4acddefba7a67b20cef9c4955e5601f80f8a0e23"
    sha256 cellar: :any,                 arm64_big_sur:  "5a9de497a3fb74b8b7fd3b1be77fcd0b808361a3adf228c04132106a16f03aa5"
    sha256 cellar: :any,                 ventura:        "c121a9b0cb9b715f535f650ad37435866862a9211923ab7d9d20cc74db3bb814"
    sha256 cellar: :any,                 monterey:       "923b8995be6b3da9742b8c283d18dbf3142f73b478b60f85f76db97c37e9b280"
    sha256 cellar: :any,                 big_sur:        "eca9cf2bbc656225f096789d5e5f5f73fc62e82aae70233835a7bb29e0e8220c"
    sha256 cellar: :any,                 catalina:       "8b868ae69e708c22e04ba3d7ab6164d31d9de5611458f6aae0a0c636b1bf6dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed8bbe73f3996dce31e082f325cb5230e6026d2067824e6ceaaceeafc146ff0c"
  end

  keg_only :provided_by_macos

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
