class Ejdb < Formula
  desc "C library based on modified version of Tokyo Cabinet"
  homepage "https://ejdb.org/"
  url "https://github.com/Softmotions/ejdb/archive/v1.2.12.tar.gz"
  sha256 "858b58409a2875eb2b0c812ce501661f1c8c0378f7756d2467a72a1738c8a0bf"
  head "https://github.com/Softmotions/ejdb.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e957a62ebddfe1efc427cc9f95ed84090d22cedfee0e1d7717ff6c57d57c8141" => :catalina
    sha256 "3be122c7eda269b79e711ed5dd0792d336c4ed6f7d879566f5c23a2e5cb88e3e" => :mojave
    sha256 "75817c5481e57bdbf55d29289f2d22dabf162810cf94308826a2c40d40904f52" => :high_sierra
    sha256 "1ef9acee32b25883f868a7148e72f5b22303b504c347711f0509d2324425fdae" => :sierra
    sha256 "6d470ca361e813d40dbff0e27ef7589d5062bba9a7b005f5b360bd595c343ded" => :el_capitan
  end

  depends_on "cmake" => :build
  uses_from_macos "bzip2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
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

          int i;
          for (i = 0; i < TCLISTNUM(res); ++i) {
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
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lejdb", "-o", testpath/"test"
    system "./test"
  end
end
