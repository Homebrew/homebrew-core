class Ejdb < Formula
  desc "Embeddable JSON Database engine C11 library"
  homepage "https://ejdb.org"
  url "https://github.com/Softmotions/ejdb.git",
      tag:      "v2.72",
      revision: "5f44c3f222b34dc9180259e37cdd1677b84d1a85"
  license "MIT"
  head "https://github.com/Softmotions/ejdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c1a23396c872b4a5e05a98ae982103cfc67da805706a091dc1c57d7770026998"
    sha256 cellar: :any,                 arm64_big_sur:  "85c60ffc351cf601c932406f75606edbf041abade468ea7ca47b2cb9a7f4cee7"
    sha256 cellar: :any,                 monterey:       "c0a2639abef7cd76b167ae19af901b9d4cca045a2b88044e9dddcf65bc1494db"
    sha256 cellar: :any,                 big_sur:        "e77d0cd2d377db7230ab9d6663f859ce9b4d59333204858851aae34bf689c54e"
    sha256 cellar: :any,                 catalina:       "13387810b1f21f9d068dfe4dd82844e19a3f4e12fa95c7fd78d8fb001a1ff6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eedee3fd1e621438e436a004062a96fc79e195f4b3b1e1358220c6cd46ace47f"
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
