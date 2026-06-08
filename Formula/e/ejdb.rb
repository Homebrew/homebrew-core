class Ejdb < Formula
  desc "Embeddable JSON Database engine C11 library"
  homepage "https://ejdb.org"
  url "https://github.com/Softmotions/ejdb.git",
      tag:      "v2.73",
      revision: "bc370d1aab86d5e2b8b15cbd7f804d3bbc6db185"
  license "MIT"
  head "https://github.com/Softmotions/ejdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c56f28aa34314717114685cbfbf7590c67747ceb211b0585bb55d97fd607049e"
    sha256 cellar: :any,                 arm64_sequoia:  "5edce24e64d4033d0cacaa8cfac387a347bb895d7ffb7d93e205581eaa4b32bd"
    sha256 cellar: :any,                 arm64_sonoma:   "e0b8000aa7f9e587b5c003bc949f897692fd67ee2e2b75024f2c4900495fd68a"
    sha256 cellar: :any,                 arm64_ventura:  "4d04af75587bace755ce51b52efbb350f21fe9ff68e627e46ba6df5c0b3d802d"
    sha256 cellar: :any,                 arm64_monterey: "651db63cf52361e30d51e00be5d21d0312a987ecf6fb13ca4db0aaa6e36419fc"
    sha256 cellar: :any,                 arm64_big_sur:  "a8c53e49e903e393a00c1f8f252f24427aa3d597621b0a60aa625fed023e47f6"
    sha256 cellar: :any,                 sonoma:         "52d1253849cb1549564033fce4841d5c0b5b67f9802eda77bd171d39b5e74279"
    sha256 cellar: :any,                 ventura:        "d1ea43ae8a72ba4c3fd46ea22cc0959a6db9ef46d99dad2443ed1896b6f745ca"
    sha256 cellar: :any,                 monterey:       "be42fe4d45f8c3ee1e9780df885e2a9176685f741ba936cc7969e7a1dffb881a"
    sha256 cellar: :any,                 big_sur:        "d015a8db5f02bc71e50daf8dfc76ac9224815abab9637bdb19bbb1adf814ad4d"
    sha256 cellar: :any,                 catalina:       "70fd430780b4d69ff1f6c63984f7f8ef01e0a478e9cf9753c6ec4b2eabed4bd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4e728b6fa0f94e81ba515b9e8d134b46846ffc6d880302c0a6557806076296ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69a8f6d1769f13275c84bb8b1bc96eb68727d85863bbf4f423f6cc6aefa1aed9"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl" => :build

  fails_with :gcc do
    version "7"
    cause <<~EOS
      build/src/extern_iwnet/src/iwnet.c: error: initializer element is not constant
      Fixed in GCC 8.1, see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=69960
    EOS
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      ENV.deparallelize # CMake Error: WSLAY Not Found
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <ejdb2/ejdb2.h>

      #define RCHECK(rc_)          \\
        if (rc_) {                 \\
          iwlog_ecode_error3(rc_); \\
          return 1;                \\
        }

      static iwrc documents_visitor(EJDB_EXEC *ctx, const EJDB_DOC doc, int64_t *step) {
        // Print document to stderr
        return jbl_as_json(doc->raw, jbl_fstream_json_printer, stderr, JBL_PRINT_PRETTY);
      }

      int main() {

        EJDB_OPTS opts = {
          .kv = {
            .path = "testdb.db",
            .oflags = IWKV_TRUNC
          }
        };
        EJDB db;     // EJDB2 storage handle
        int64_t id;  // Document id placeholder
        JQL q = 0;   // Query instance
        JBL jbl = 0; // Json document

        iwrc rc = ejdb_init();
        RCHECK(rc);

        rc = ejdb_open(&opts, &db);
        RCHECK(rc);

        // First record
        rc = jbl_from_json(&jbl, "{\\"name\\":\\"Bianca\\", \\"age\\":4}");
        RCGO(rc, finish);
        rc = ejdb_put_new(db, "parrots", jbl, &id);
        RCGO(rc, finish);
        jbl_destroy(&jbl);

        // Second record
        rc = jbl_from_json(&jbl, "{\\"name\\":\\"Darko\\", \\"age\\":8}");
        RCGO(rc, finish);
        rc = ejdb_put_new(db, "parrots", jbl, &id);
        RCGO(rc, finish);
        jbl_destroy(&jbl);

        // Now execute a query
        rc =  jql_create(&q, "parrots", "/[age > :age]");
        RCGO(rc, finish);

        EJDB_EXEC ux = {
          .db = db,
          .q = q,
          .visitor = documents_visitor
        };

        // Set query placeholder value.
        // Actual query will be /[age > 3]
        rc = jql_set_i64(q, "age", 0, 3);
        RCGO(rc, finish);

        // Now execute the query
        rc = ejdb_exec(&ux);

      finish:
        if (q) jql_destroy(&q);
        if (jbl) jbl_destroy(&jbl);
        ejdb_close(&db);
        RCHECK(rc);
        return 0;
      }
    C

    system ENV.cc, "-I#{include}/ejdb2", "test.c", "-L#{lib}", "-lejdb2", "-o", testpath/"test"
    system "./test"
  end
end
