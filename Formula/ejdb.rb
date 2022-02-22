class Ejdb < Formula
  desc "Embeddable JSON Database engine C11 library"
  homepage "https://ejdb.org"
  url "https://github.com/Softmotions/ejdb.git",
      tag:      "v2.71",
      revision: "392da086773d008ab5cee0efd88b04fcbc1c2647"
  license "MIT"
  head "https://github.com/Softmotions/ejdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "817fec794187f5fd2fb91810a3abfcece5bafc3d966356f3c620f146f0f1db6e"
    sha256 cellar: :any,                 arm64_big_sur:  "39ac08c2bf487e69edc24513104833577e98418cf85ed6bf8bd5e9dee3b2d2cc"
    sha256 cellar: :any,                 monterey:       "55dee0277b2029780dc190425087cda70805f2940e8e68e3c5953661b717421f"
    sha256 cellar: :any,                 big_sur:        "121e98f6fe60ee3141e05c1fa1d2ee90cde39fcb8d7942d1a4d98136bfafac96"
    sha256 cellar: :any,                 catalina:       "149f1c909e99bf5db31164d2991a6fc012820dbfbaeba9e4169c991492b5c496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0f77a523af86213cebe9a85850df597f078bde8e574b279de74fcc2f42ce5e4"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl" => :build

  on_linux do
    depends_on "gcc" => [:build, :test]
  end

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
