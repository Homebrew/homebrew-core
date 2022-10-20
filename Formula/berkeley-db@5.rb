class BerkeleyDbAT5 < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/database/technologies/related/berkeleydb.html"
  url "https://download.oracle.com/berkeley-db/db-5.3.28.tar.gz"
  sha256 "e0a992d740709892e81f9d93f06daf305cf73fb81b545afe72478043172c3628"
  license "Sleepycat"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3552b61376eea832cbc2a763c725c77c56f0ce3c94b72cb80acdb5b6b26d7e45"
    sha256 cellar: :any,                 arm64_big_sur:  "55d4b9058c542dd9a9e90915c45fa0e4aaf4a2d9d5564df08acc4b6b2b0febb7"
    sha256 cellar: :any,                 monterey:       "ac63e0443e2c939ca35be34dda37e8fe978c2ce97ca7f387972ffcb7a58437a4"
    sha256 cellar: :any,                 big_sur:        "7e3d143445f45d8a2b0483d0d67e6d850d31304e39b5186999359788aada498b"
    sha256 cellar: :any,                 catalina:       "5d16240f2a7ff2d057db048058d9b0644e152e50989f78ce66121e6350afa8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b494da812a74d56cb31bcca41dcff11e82cf84dfbaeca52a6923ef7f2882578"
  end

  keg_only :versioned_formula

  # Fix build with recent clang
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4c55b1/berkeley-db%404/clang.diff"
    sha256 "86111b0965762f2c2611b302e4a95ac8df46ad24925bbb95a1961542a1542e40"
    directory "src"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    directory "dist"
  end

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    # Work around issues ./configure has with Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    args = %W[
      --disable-static
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-cxx
    ]

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd "build_unix" do
      system "../dist/configure", *args
      system "make", "install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix+"docs", doc
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
