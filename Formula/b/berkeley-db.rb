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

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "422be2c8877f981442a27bd80d7a4494de3a515b54b1d206e51c4e710f9d83eb"
    sha256 cellar: :any,                 arm64_sonoma:   "f8a6da9be201214ca17efa824a335060a6f1ff4d72cc579a5878ee06ac2d9b61"
    sha256 cellar: :any,                 arm64_ventura:  "67fed25d26cb987106b346ee4088959b71306db6a016cb6f58cca9da9350c36d"
    sha256 cellar: :any,                 arm64_monterey: "e5416a45caf56653c4691f5d939df58d9da2254807efd6ab5425cfa63a472ac9"
    sha256 cellar: :any,                 arm64_big_sur:  "a68f9cf2daa3a03ea5c9c9e072955d2dec43aff19859ef2c40888b7b85ea379f"
    sha256 cellar: :any,                 sonoma:         "01746c62817e50160208bd9acb690eec9352e89b5a3b8bda6bea3952b9bc4352"
    sha256 cellar: :any,                 ventura:        "a6b04772ee3978ec98f1e3e79fec872c9dc5476b49b7d70218e5c850af6ecf79"
    sha256 cellar: :any,                 monterey:       "6db05f803f05820f25cdd5936a8d23615ef886f0a409946d40d966cf5f35f023"
    sha256 cellar: :any,                 big_sur:        "5f4917a225a5986f682c85dbcfb6503024738d6eadb637161210ae621c26f457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba948d2977fbfcc865086fab6d6567b4f3972fcc46e327817fb7600f64d4312"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

  on_linux do
    resource "libdb1.85" do
      # NOTE: Debian's source version reflects Glib's version, not libdb1's version
      # It also fixes security bug: https://insecure.org/sploits/libdb.snprintf.redefine.html
      url "http://deb.debian.org/debian/pool/main/d/db1-compat/db1-compat_2.1.3.orig.tar.gz"
      sha256 "b01f560f00a67f921e678586d903969015b0c9cec6c18b1679b7e9fd6d27394e"
    end
    resource "libdb1.85-patches" do
      url "http://deb.debian.org/debian/pool/main/d/db1-compat/db1-compat_2.1.3-25.debian.tar.xz"
      sha256 "5c3773cf41105ccbe9d07d42b90013e40ab09b8f615d5cecbac298aa72cbb9db"
    end
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    directory "dist"
  end

  def install
    # Work around undefined NULL causing incorrect detection of thread local storage class
    ENV.append "CFLAGS", "-include stddef.h" if DevelopmentTools.clang_build_version >= 1500
    ENV.append "CFLAGS", "-Wno-error=implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize

    # db_dump185 needs libdb 1.85 on Linux only (macOS & BSD variants already have it)
    if OS.linux?
      resource("libdb1.85").stage do
        libdb1_src_path = Pathname(Utils.safe_popen_read("pwd").chomp).realpath

        resource("libdb1.85-patches").stage do
          File.read("patches/series").each_line do |p|
            # Omit db_dump185.patch: it includes another version of the entire db_dump185 source code
            # We will use the version included with Oracle upstream's source instead, and link against libdb1
            # See build doc: Chapter 6. Building Berkeley DB for UNIX/POSIX - Architecture independent FAQ #8
            # NOTE: PDF footer labeled p. 49, but URL page num differs
            # https://www.oracle.com/technetwork/database/berkeleydb/bdb-installation-160957.pdf#page=66
            next if p.match?(/^(db_dump185\.patch)/)

            patch_fullpath = Pathname(File.join("patches", p.chomp)).realpath
            cd libdb1_src_path do
              system "patch", "-g", "0", "-f", "-p1", "-i", patch_fullpath
            end
          end
        end
        system "make"
        include.install "db.h"
        lib.install "libdb1.so.2"
        ln_s "libdb1.so.2", lib/"libdb1.so"
      end
    end

    # --enable-compat185 is necessary because our build shadows
    # the system berkeley db 1.x
    # --enable-dump185 Builds the db_dump185 utility, which can dump Berkeley DB 1.85 and 1.86 databases.
    # See: https://docs.oracle.com/cd/E17275_01/html/programmer_reference/build_unix_conf.html#build_unix_conf
    args = %W[
      --disable-debug
      --disable-static
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-cxx
      --enable-compat185
      --enable-dump185
      --enable-sql
      --enable-sql_codegen
      --enable-dbm
      --enable-stl
    ]

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd "build_unix" do
      if OS.linux?
        args << "CPPFLAGS=-I#{include}"
        db185_linkerflags = "-Xlinker '-L #{lib}' -Xlinker '-l db1'"
        inreplace "../dist/Makefile.in", /^DB185LIB=.*/, "DB185LIB=#{db185_linkerflags}"
      end

      system "../dist/configure", *args
      system "make", "install", "DOCLIST=license"

      # delete docs dir because it is huge
      rm_r(prefix/"docs")
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
