class Ejdb < Formula
  desc "Embeddable JSON Database engine C11 library"
  homepage "https://ejdb.org"
  url "https://github.com/Softmotions/ejdb.git",
      tag:      "v2.91",
      revision: "abe62bfdb02c489e88f867ca1bcb8e076a00391e"
  license "MIT"
  head "https://github.com/Softmotions/ejdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d5446f90218cf7ad8453dfda791e333e23e1eb05ab0c1c878f2a6423f176432f"
    sha256 cellar: :any, arm64_tahoe:       "19fd0019dbb36e24cb3cb5af20cd2d0f4dc3b05541093378794d27460ede600a"
    sha256 cellar: :any, arm64_sequoia:     "3e68daeb3b55a4b748cdf830ec3de7e2b1657d48ebe3c7b79b6c80688f805bc4"
    sha256 cellar: :any, arm64_sonoma:      "65d4e0eb5a0ba672a7844b046c850f712dd8e38a3e65a8a4d6738e29546f2f0b"
    sha256 cellar: :any, arm64_linux:       "a524ef1c4b6286c83d37d9b7d371979c5abbe64a803ffb5fb363b5678ccb2c53"
    sha256 cellar: :any, x86_64_linux:      "795ebc2ceb0046e6ba58ff0652f08ea98ca0406a671564b277c5f07930b4cc85"
  end

  depends_on "pkgconf" => :build

  fails_with :gcc do
    version "7"
    cause <<~EOS
      build/src/extern_iwnet/src/iwnet.c: error: initializer element is not constant
      Fixed in GCC 8.1, see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=69960
    EOS
  end

  resource "iwnet" do
    url "https://github.com/Softmotions/iwnet/archive/refs/tags/v1.3.1.tar.gz"
    sha256 "2f6bee87943dd383f4d86f18f907fe078bbb09fdb1cb828c9abe297d18435478"

    # Fix macOS builds, upstream PR ref, https://github.com/Softmotions/iwnet/pull/11
    patch do
      url "https://github.com/Softmotions/iwnet/commit/f11675b71373f561d9c0690e2f4cc4044f666a15.patch?full_index=1"
      sha256 "446667fcc1cded631c39071786499680a54c7d38a70e4537802da4006cacff3f"
      type :unofficial
    end
  end

  resource "iowow" do
    url "https://github.com/Softmotions/iowow/archive/refs/tags/v1.5.2.tar.gz"
    sha256 "24b91edcc69a48a752b2a1892a0b935e980afb8a04eb659c699e77d29253ab61"
  end

  # Fix Autark shared builds, upstream PR ref, https://github.com/Softmotions/ejdb/pull/395
  patch do
    url "https://github.com/Softmotions/ejdb/commit/cfe8dbcf2650333372d9b943315aeee90e5a5d9d.patch?full_index=1"
    sha256 "2df85c7d810f91a434e505868aa33f8e86ba7cf8b975fce457636c290f941234"
    type :unofficial
  end

  deny_network_access! :test

  def install
    resources.each do |r|
      r.stage buildpath/r.name
    end

    # Keep dependency libraries in Homebrew's lib directory on Linux too.
    inreplace ["Autark", "iwnet/iowow.autark"], "--prefix", "--libdir=lib --prefix"

    # Use the staged resource instead of downloading the development branch.
    inreplace "iwnet/iowow.autark",
              "https://github.com/Softmotions/iowow/archive/refs/heads/master.zip",
              "dir://#{buildpath}/iowow"

    system "./build.sh", "--prefix=#{prefix}", "--libdir=lib", "--jobs=#{ENV.make_jobs}",
                         "-DIWNET_URL=dir://#{buildpath}/iwnet", "-DEJDB_BUILD_SHARED_LIBS=1"
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

    system ENV.cc, "-I#{include}/ejdb2", "test.c", "-L#{lib}", "-Wl,-rpath,#{lib}", "-lejdb2", "-o", testpath/"test"
    system "./test"
  end
end
