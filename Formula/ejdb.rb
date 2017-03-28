class Ejdb < Formula
  desc "C library based on modified version of Tokyo Cabinet"
  homepage "http://ejdb.org"
  url "https://github.com/Softmotions/ejdb/archive/v1.2.12.tar.gz"
  sha256 "858b58409a2875eb2b0c812ce501661f1c8c0378f7756d2467a72a1738c8a0bf"

  head "https://github.com/Softmotions/ejdb.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d48da7bc7966e2be2c5c460f99d0e724794af118d66113276324047f92373478" => :sierra
    sha256 "1c641947e4fc5f639050f49421ad28701fb91a3f91884e46af81030ec4fff607" => :el_capitan
    sha256 "c349070a47065657f970481d75e39045ede6762f97059c25cdd2f90a764d75f4" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ejdb/ejdb.h>

      static EJDB *jb;
      int main() {
          jb = ejdbnew();
          if (!ejdbopen(jb, "addressbook", JBOWRITER | JBOCREAT | JBOTRUNC)) {
              return 1;
          }
          EJCOLL *coll = ejdbcreatecoll(jb, "contacts", NULL);

          bson bsrec;
          bson_oid_t oid;

          bson_init(&bsrec);
          bson_append_string(&bsrec, "name", "Bruce");
          bson_append_string(&bsrec, "phone", "333-222-333");
          bson_append_int(&bsrec, "age", 58);
          bson_finish(&bsrec);

          ejdbsavebson(coll, &bsrec, &oid);
          bson_destroy(&bsrec);

          bson bq1;
          bson_init_as_query(&bq1);
          bson_append_start_object(&bq1, "name");
          bson_append_string(&bq1, "$begin", "Bru");
          bson_append_finish_object(&bq1);
          bson_finish(&bq1);

          EJQ *q1 = ejdbcreatequery(jb, &bq1, NULL, 0, NULL);

          uint32_t count;
          TCLIST *res = ejdbqryexecute(coll, q1, &count, 0, NULL);

          for (int i = 0; i < TCLISTNUM(res); ++i) {
              void *bsdata = TCLISTVALPTR(res, i);
              bson_print_raw(bsdata, 0);
          }
          tclistdel(res);

          ejdbquerydel(q1);
          bson_destroy(&bq1);

          ejdbclose(jb);
          ejdbdel(jb);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lejdb",
           "test.c", "-o", testpath/"test"
    system "./test"
  end
end
