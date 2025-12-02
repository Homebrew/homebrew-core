class BerkeleyDbAT5 < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/database/technologies/related/berkeleydb.html"
  url "https://download.oracle.com/berkeley-db/db-5.3.28.tar.gz"
  sha256 "e0a992d740709892e81f9d93f06daf305cf73fb81b545afe72478043172c3628"
  license "Sleepycat"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a713c6c74511eb18a8dc92c92bbb1b7ca3f1e7c71c3325ab584634e6275ab1bd"
    sha256 cellar: :any,                 arm64_sequoia:  "ac64ff01e9897372c22dd2f9c90a2e5ffc5b66876c243d20d1e107b7c3785fba"
    sha256 cellar: :any,                 arm64_sonoma:   "7e1f6f67ce491e8636f9095fa45854e7b5720745b909e3b84cad8400b28418fd"
    sha256 cellar: :any,                 arm64_ventura:  "65a70e28dcf089e0ec6d247c32df257c8bc2532ece6f4c447200a48e7ad17a8d"
    sha256 cellar: :any,                 arm64_monterey: "8c9ea685725256b2b50e856c23d20af734f20bc69fc92383e1819e4f867c8ac3"
    sha256 cellar: :any,                 arm64_big_sur:  "9ef4df0db041470e7eba4335524ea0348f0061bd4e10ab7a7f6051841f7a7e11"
    sha256 cellar: :any,                 sonoma:         "db128eb3926e9941b0db4aaf52df8848c74194128712f153f46df7810395ff5e"
    sha256 cellar: :any,                 ventura:        "7fdd38c90e7bfcb57b4a061423d38602471f568e37393820889ee56d1c9fd003"
    sha256 cellar: :any,                 monterey:       "36aaa79c9fc3eb2b7690c24bdf74be3d0f7e1752983a63a17538945e2bce7452"
    sha256 cellar: :any,                 big_sur:        "5aa0875cdd7bd504abf8f7365e47f5ac4b0e1b9e4ca004d6eb58e2f1564a9621"
    sha256 cellar: :any,                 catalina:       "944b439dd5dcb02c5219b307d6ed739b9808a4eced27f6605a977e550e47c8bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "356a948ed9ce8a65a5f280c5f68c0bb7d750ab962c06485c7972f557d779acf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0e2906cc6657dc497fec75629560b0a404b81cebadf5e10c1f70616a14fa886"
  end

  keg_only :versioned_formula

  # We use a resource to avoid potential build dependency loop in future. Right now this
  # doesn't happen because `perl` depends on `berkeley-db`, but the dependency may change
  # to `berkeley-db@5`. In this case, `automake -> autoconf -> perl` will create a loop.
  # Ref: https://github.com/Homebrew/homebrew-core/issues/100796
  resource "automake" do
    on_linux do
      on_arm do
        url "https://ftpmirror.gnu.org/gnu/automake/automake-1.16.5.tar.xz"
        mirror "https://ftp.gnu.org/gnu/automake/automake-1.16.5.tar.xz"
        sha256 "f01d58cd6d9d77fbdca9eb4bbd5ead1988228fdb73d6f7a201f5f8d6b118b469"
      end
    end
  end

  # Fix build with recent clang
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/berkeley-db@4/clang.diff"
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
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    directory "dist"
  end

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    # Work around ancient config files not recognizing aarch64 linux
    # configure: error: cannot guess build type; you must specify one
    if OS.linux? && Hardware::CPU.arm?
      resource("automake").stage do
        (buildpath/"dist").install "lib/config.guess", "lib/config.sub"
      end
    end

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
      mv prefix/"docs", doc
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    flags = %W[
      -I#{include}
      -L#{lib}
      -ldb_cxx
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
    assert_path_exists testpath/"test.db"
  end
end
