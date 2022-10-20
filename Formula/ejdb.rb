class Ejdb < Formula
  desc "Embeddable JSON Database engine C11 library"
  homepage "https://ejdb.org"
  url "https://github.com/Softmotions/ejdb.git",
      tag:      "v2.72",
      revision: "5f44c3f222b34dc9180259e37cdd1677b84d1a85"
  license "MIT"
  head "https://github.com/Softmotions/ejdb.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "69a64cfcbe98217a61763412b2b316e19554a65a06600882cba26d25d466230d"
    sha256 cellar: :any,                 arm64_big_sur:  "5b26fb93753b6d5a9527f99dd96678d36c5becf5a17c549f662add76ff6cc771"
    sha256 cellar: :any,                 monterey:       "8c9c2779172207ef97a8c615900e0b43a3a6da7d79b662c73a08fd07be4aa553"
    sha256 cellar: :any,                 big_sur:        "9db2ff193af94e86a814c5ef2d5c11694f6b9adbab3609b93532524ce6f22fdd"
    sha256 cellar: :any,                 catalina:       "ca6328c694618eda86c806b067781b3fbd1f4b2b0bd740735b4c4a965733acc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a4a69b69695ea65b09ddb7dc9cf8a3fcf9b35df61e35231a1bcece3855bac91"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl" => :build

  fails_with :gcc do
    version "7"
    cause <<-EOS
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
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lejdb2", "-o", testpath/"test"
    system "./test"
  end
end
