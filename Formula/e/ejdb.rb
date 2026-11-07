class Ejdb < Formula
  desc "Embeddable JSON Database engine C11 library"
  homepage "https://ejdb.org"
  url "https://github.com/Softmotions/ejdb.git",
      tag:      "v2.98",
      revision: "d4c75c48f2bbd685b5d92c4f25a0f0318a10cb1a"
  license "MIT"
  head "https://github.com/Softmotions/ejdb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "13cbefe006aaef3709339b570aedade88ecf33114cce9ac48d5917e226700ccf"
    sha256 cellar: :any, arm64_tahoe:       "14f22210d739c885db397e6badc374ed565e09b55420609fa4a1b0f8516b6700"
    sha256 cellar: :any, arm64_sequoia:     "e9c1b3794e4905f1bd2b99ccaa75bdb9d1408745046ea62ca6fdae72d83d2c00"
    sha256 cellar: :any, arm64_linux:       "dd2dd6fd181191b87d3f9acbfc0e80baca9daf4708d59e1fc301f33caf793b3e"
    sha256 cellar: :any, x86_64_linux:      "0a9a8eb9961aca37ae0c974c98b9155e617afd894a2b2c805eb9b67255c90196"
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
    url "https://github.com/Softmotions/iwnet/archive/refs/tags/v1.6.0.tar.gz"
    sha256 "f7acd2625f3327bb854c8eae199ac59d9816f9678f3f4b3712b818231ae1185c"

    livecheck do
      url "https://raw.githubusercontent.com/Softmotions/ejdb/refs/tags/v#{LATEST_VERSION}/Autark"
      regex(%r{/iwnet/archive/refs/tags/v?(\d+(?:\.\d+)+)\.zip}i)
    end
  end

  # iowow is pinned by iwnet rather than ejdb, so follow iwnet's default branch
  resource "iowow" do
    url "https://github.com/Softmotions/iowow/archive/refs/tags/v1.7.3.tar.gz"
    sha256 "ede6541dcad267801482c169f484afc7128a0ca899943af001fab76c1ffb2583"

    livecheck do
      url "https://raw.githubusercontent.com/Softmotions/iwnet/refs/heads/master/iowow.autark"
      regex(%r{/iowow/archive/refs/tags/v?(\d+(?:\.\d+)+)\.zip}i)
    end
  end

  deny_network_access! :test

  def install
    resources.each do |r|
      r.stage buildpath/r.name
    end

    # Keep dependency libraries in Homebrew's lib directory on Linux too.
    inreplace ["iwnet.autark", "iwnet/iowow.autark"], "--prefix", "--libdir=lib --prefix"

    # Use the staged resource instead of downloading it.
    inreplace "iwnet/iowow.autark",
              %r{https://github\.com/Softmotions/iowow/archive/\S+\.zip},
              "dir://#{buildpath}/iowow"

    # Bundled peg's `make install` can copy its man page before creating the directory
    jobs = ENV.make_jobs
    ENV.deparallelize

    system "./build.sh", "--prefix=#{prefix}", "--libdir=lib", "--jobs=#{jobs}",
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
