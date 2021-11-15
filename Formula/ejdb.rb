class Ejdb < Formula
  desc "Embeddable JSON Database engine C11 library"
  homepage "https://ejdb.org"
  url "https://github.com/Softmotions/ejdb/archive/v2.62.tar.gz"
  sha256 "8369b09483bb639c6cbc75a307a7ac5d605740c44c9281bad6df0748eaf7bbd6"
  license "MIT"
  head "https://github.com/Softmotions/ejdb.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2c80641ca8f801cfbf20f0da4cf9612aa12c22975362235da788b89ec54f1b5b"
    sha256 cellar: :any,                 arm64_big_sur:  "7bbd139116b2a6b85e30aaece1637c4f6828d465b8982f33242b562c46eeee0b"
    sha256 cellar: :any,                 monterey:       "3fa834a6ca34a7e964a3bbc395edb5e22fc8a58d9d23077679de80267d68850e"
    sha256 cellar: :any,                 big_sur:        "d86d8dff6fc510f15a659b6cdb6c7656fe06999c9fea1e5fa5e41b03bc898987"
    sha256 cellar: :any,                 catalina:       "4ea564bb023a59c3c54523e64dc6ff7c34c6d5e21cf06810ae7e7ada2649be35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44ac2dd666214547d6b3440517d389d82618cf598880fc3a6bf6d562d4c54667"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
