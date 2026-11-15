class BerkeleyDb < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/database/technologies/related/berkeleydb.html"
  url "https://download.oracle.com/berkeley-db/db-18.1.40.tar.gz"
  mirror "https://fossies.org/linux/misc/db-18.1.40.tar.gz"
  sha256 "0cecb2ef0c67b166de93732769abdeba0555086d51de1090df325e18ee8da9c8"
  license "AGPL-3.0-only"
  revision 4
  compatibility_version 1

  livecheck do
    url "https://www.oracle.com/database/technologies/related/berkeleydb-downloads.html"
    regex(%r{/berkeleydb/html/changelog[._-]v?(\d+(?:[._]\d+)+)\.html?}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9a6b14a95512978cc752fe673e49ad604422350f72beb47c7f9f1676b8277164"
    sha256 cellar: :any, arm64_tahoe:       "d94e51bc4878ddf195920e8a64c9f1ec2f513671c64c2862937ae034d5e3708f"
    sha256 cellar: :any, arm64_sequoia:     "56f53021c4758ce4b4860aa1b6567f2128c5badabb6ebd8c3fd87d093e24c05a"
    sha256 cellar: :any, arm64_linux:       "aae5235e0a9113eb9f9193e98823f90cc07ddc74061c819a778c999ed6515945"
    sha256 cellar: :any, x86_64_linux:      "c94fb50d96ac4591613e5432955dadb3cf352a4f2412ccf7758df1776505b674"
  end

  keg_only :provided_by_macos

  depends_on "openssl@4"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    directory "dist"
    type :unofficial
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
