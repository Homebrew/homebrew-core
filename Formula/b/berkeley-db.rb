class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/database/technologies/related/berkeleydb.html"
  url "https://download.oracle.com/berkeley-db/db-18.1.40.tar.gz"
  mirror "https://fossies.org/linux/misc/db-18.1.40.tar.gz"
  sha256 "0cecb2ef0c67b166de93732769abdeba0555086d51de1090df325e18ee8da9c8"
  license "AGPL-3.0-only"
  revision 3

  livecheck do
    url "https://www.oracle.com/database/technologies/related/berkeleydb-downloads.html"
    regex(/Berkeley\s*DB[^(]*?\(\s*v?(\d+(?:\.\d+)+)\s*\)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c80c2a5549d9231b046f5054c7e3bd091bc4accb52f8c3b6aac303ac73d9898"
    sha256 cellar: :any,                 arm64_sequoia: "61883ff98a6fabd76485d7eb3d8ce2beea6a36cde795abbfaa3f68188d343d44"
    sha256 cellar: :any,                 arm64_sonoma:  "719a0104dfb17a271589beb545024fcd68abc211930f5d550b6cc7438bc9a89c"
    sha256 cellar: :any,                 sonoma:        "7bb183ccef1018e2bd5b855725c69d8aac655c60f8b6f21acd1a1cf3a18ba076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dd18cc81b181da169f1617c705d14c3ff394c821a55556cf35c80357c97c65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e7a13dfbaf54be80e7e35d126bd206f1e3bc6a7fde8c80fc60c680b3325e473"
  end

  keg_only :provided_by_macos

  depends_on "openssl@4"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    directory "dist"
  end

  def install
    # Work around undefined NULL causing incorrect detection of thread local storage class
    ENV.append "CFLAGS", "-include stddef.h" if DevelopmentTools.clang_build_version >= 1500

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
      rm_r(prefix/"docs")
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
