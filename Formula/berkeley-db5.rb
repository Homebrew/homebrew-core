class BerkeleyDb5 < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/technology/products/berkeley-db/index.html"
  url "http://download.oracle.com/berkeley-db/db-5.3.28.tar.gz"
  sha256 "e0a992d740709892e81f9d93f06daf305cf73fb81b545afe72478043172c3628"

  bottle do
    cellar :any
    revision 1
    sha1 "a134b5effaa73fd296b2601180520292c0a6d095" => :yosemite
    sha1 "910660e253bf32a1ce730d4ba27e3090f645f5f6" => :mavericks
    sha1 "aaafa41026335a6b7e6c0792d1511325c79409fa" => :mountain_lion
  end

  keg_only "BDB 5.3.28 is provided for software that doesn't compile against newer versions."

  option "with-java", "Compile with Java support."
  option "with-sql", "Compile with SQL support."

  deprecated_option "enable-sql" => "with-sql"

  # Fix build under Xcode 4.6
  # Double-underscore names are reserved, and __atomic_compare_exchange is now
  # a built-in, so rename this to something non-conflicting.
  patch :DATA

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    # --enable-compat185 is necessary because our build shadows
    # the system berkeley db 1.x
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-cxx
      --enable-compat185
    ]
    args << "--enable-java" if build.with? "java"
    args << "--enable-sql" if build.with? "sql"

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd "build_unix" do
      system "../dist/configure", *args
      system "make", "install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix/"docs", doc
    end
  end

  test do
    db = testpath/"school.db"
    path = testpath/"school.txt"
    path.write <<-EOS.undent
      Bob
      14
      Sue
      12
      Tim
      13
    EOS
    dump = testpath/"school.out"

    system "#{bin}/db_load -t btree -T #{db} < #{path}"
    system "#{bin}/db_dump -p #{db} > #{dump}"
    # filter out the DATA from the HEADER, in the portable flat-text format
    assert_equal shell_output("grep '^ ' #{dump} | sed -e 's/^ //'"), path.read
  end
end

__END__
diff --git a/src/dbinc/atomic.h b/src/dbinc/atomic.h
index 096176a..561037a 100644
--- a/src/dbinc/atomic.h
+++ b/src/dbinc/atomic.h
@@ -144,7 +144,7 @@ typedef LONG volatile *interlocked_val;
 #define	atomic_inc(env, p)	__atomic_inc(p)
 #define	atomic_dec(env, p)	__atomic_dec(p)
 #define	atomic_compare_exchange(env, p, o, n)	\
-	__atomic_compare_exchange((p), (o), (n))
+	__atomic_compare_exchange_db((p), (o), (n))
 static inline int __atomic_inc(db_atomic_t *p)
 {
 	int	temp;
@@ -176,7 +176,7 @@ static inline int __atomic_dec(db_atomic_t *p)
  * http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html
  * which configure could be changed to use.
  */
-static inline int __atomic_compare_exchange(
+static inline int __atomic_compare_exchange_db(
 	db_atomic_t *p, atomic_value_t oldval, atomic_value_t newval)
 {
 	atomic_value_t was;
