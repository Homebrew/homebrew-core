class LibpqxxAT3 < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "http://pqxx.org/download/software/libpqxx/libpqxx-3.1.1.tar.gz"
  sha256 "ce443c7c515623b4a68de5f0657460344b6b6320982d8f8efc657c3746e1ee90"

  bottle do
    cellar :any
    sha256 "4623a2180c2549b24afafdad9ba9f955dea86622a86a55f6fb5a2a8f51f0b940" => :sierra
    sha256 "ebcbc05990beae2947235e4f6cdb1b79482e60c5cff45fb2fced7d61c8fd5fa8" => :el_capitan
    sha256 "f94adb2b8bd5ad25bb7db51a79bdde7c167912bc4d2134822d70f1a45827d3bc" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on :postgresql

  # Patch 1 borrowed from MacPorts. See:
  # https://trac.macports.org/ticket/33671
  #
  # (1) Patched maketemporary to avoid an error message about improper use
  #     of the mktemp command; apparently maketemporary is designed to call
  #     mktemp in various ways, some of which may be improper, as it attempts
  #     to determine how to use it properly; we don't want to see those errors
  #     in the configure phase output.
  # (2) Patched largeobject.hxx per the ticket at the following URL:
  #     http://pqxx.org/development/libpqxx/ticket/252
  patch :DATA

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end
end

__END__
diff --git a/tools/maketemporary b/tools/maketemporary
index 242f63b..f9f6661 100755
--- a/tools/maketemporary
+++ b/tools/maketemporary
@@ -5,7 +5,7 @@
 TMPDIR="${TMPDIR:-/tmp}"
 export TMPDIR

-T="`mktemp`"
+T="`mktemp 2>/dev/null`"
 if test -z "$T" ; then
	      T="`mktemp -t pqxx.XXXXXX`"
 fi
diff --git a/include/pqxx/largeobject.hxx b/include/pqxx/largeobject.hxx
index 73d16c0..b2caeed 100644
--- a/include/pqxx/largeobject.hxx
+++ b/include/pqxx/largeobject.hxx
@@ -396,7 +396,7 @@ public:
			openmode mode = PGSTD::ios::in | PGSTD::ios::out,
			size_type BufSize=512) :			//[t48]
     m_BufSize(BufSize),
-    m_Obj(T, O),
+    m_Obj(T, O, mode),
     m_G(0),
     m_P(0)
	{ initialize(mode); }
@@ -406,7 +406,7 @@ public:
			openmode mode = PGSTD::ios::in | PGSTD::ios::out,
			size_type BufSize=512) :			//[t48]
     m_BufSize(BufSize),
-    m_Obj(T, O),
+    m_Obj(T, O, mode),
     m_G(0),
     m_P(0)
	{ initialize(mode); }
