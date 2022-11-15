class BerkeleyDbAT5 < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/database/technologies/related/berkeleydb.html"
  url "https://download.oracle.com/berkeley-db/db-5.3.28.tar.gz"
  sha256 "e0a992d740709892e81f9d93f06daf305cf73fb81b545afe72478043172c3628"
  license "Sleepycat"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "65a70e28dcf089e0ec6d247c32df257c8bc2532ece6f4c447200a48e7ad17a8d"
    sha256 cellar: :any,                 arm64_monterey: "8c9ea685725256b2b50e856c23d20af734f20bc69fc92383e1819e4f867c8ac3"
    sha256 cellar: :any,                 arm64_big_sur:  "9ef4df0db041470e7eba4335524ea0348f0061bd4e10ab7a7f6051841f7a7e11"
    sha256 cellar: :any,                 ventura:        "7fdd38c90e7bfcb57b4a061423d38602471f568e37393820889ee56d1c9fd003"
    sha256 cellar: :any,                 monterey:       "36aaa79c9fc3eb2b7690c24bdf74be3d0f7e1752983a63a17538945e2bce7452"
    sha256 cellar: :any,                 big_sur:        "5aa0875cdd7bd504abf8f7365e47f5ac4b0e1b9e4ca004d6eb58e2f1564a9621"
    sha256 cellar: :any,                 catalina:       "944b439dd5dcb02c5219b307d6ed739b9808a4eced27f6605a977e550e47c8bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0e2906cc6657dc497fec75629560b0a404b81cebadf5e10c1f70616a14fa886"
  end

  keg_only :versioned_formula

  # Fix build with recent clang
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4c55b1/berkeley-db%404/clang.diff"
    sha256 "86111b0965762f2c2611b302e4a95ac8df46ad24925bbb95a1961542a1542e40"
    directory "src"
  end

  # Further fixes for clang
  patch :p0 do
    url "https://raw.githubusercontent.com/NetBSD/pkgsrc/6034096dc85159a02116524692545cf5752c8f33/databases/db5/patches/patch-src_dbinc_db.in"
    sha256 "302b78f3e1f131cfbf91b24e53a5c79e1d9234c143443ab936b9e5ad08dea5b6"
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
      --enable-dbm
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
