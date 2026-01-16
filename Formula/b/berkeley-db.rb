class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/database/technologies/related/berkeleydb.html"
  url "https://download.oracle.com/berkeley-db/db-18.1.40.tar.gz"
  mirror "https://fossies.org/linux/misc/db-18.1.40.tar.gz"
  sha256 "0cecb2ef0c67b166de93732769abdeba0555086d51de1090df325e18ee8da9c8"
  license "AGPL-3.0-only"
  revision 2

  livecheck do
    url "https://www.oracle.com/database/technologies/related/berkeleydb-downloads.html"
    regex(/Berkeley\s*DB[^(]*?\(\s*v?(\d+(?:\.\d+)+)\s*\)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "8ab6e76001b5a945ed16eaa85a4a5676bd3a7f54365c2255c90565d73096ff0e"
    sha256 cellar: :any,                 arm64_sequoia:  "422be2c8877f981442a27bd80d7a4494de3a515b54b1d206e51c4e710f9d83eb"
    sha256 cellar: :any,                 arm64_sonoma:   "f8a6da9be201214ca17efa824a335060a6f1ff4d72cc579a5878ee06ac2d9b61"
    sha256 cellar: :any,                 arm64_ventura:  "67fed25d26cb987106b346ee4088959b71306db6a016cb6f58cca9da9350c36d"
    sha256 cellar: :any,                 arm64_monterey: "e5416a45caf56653c4691f5d939df58d9da2254807efd6ab5425cfa63a472ac9"
    sha256 cellar: :any,                 arm64_big_sur:  "a68f9cf2daa3a03ea5c9c9e072955d2dec43aff19859ef2c40888b7b85ea379f"
    sha256 cellar: :any,                 sonoma:         "01746c62817e50160208bd9acb690eec9352e89b5a3b8bda6bea3952b9bc4352"
    sha256 cellar: :any,                 ventura:        "a6b04772ee3978ec98f1e3e79fec872c9dc5476b49b7d70218e5c850af6ecf79"
    sha256 cellar: :any,                 monterey:       "6db05f803f05820f25cdd5936a8d23615ef886f0a409946d40d966cf5f35f023"
    sha256 cellar: :any,                 big_sur:        "5f4917a225a5986f682c85dbcfb6503024738d6eadb637161210ae621c26f457"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8ae89765b5bcd261562a5dd527459d9fadb46d2aa264240b634e0acc21076a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba948d2977fbfcc865086fab6d6567b4f3972fcc46e327817fb7600f64d4312"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

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
