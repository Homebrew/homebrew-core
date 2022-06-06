class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.2/pgloader-bundle-3.6.2.tgz"
  sha256 "e35b8c2d3f28f3c497f7e0508281772705940b7ae789fa91f77c86c0afe116cb"
  license "PostgreSQL"
  revision 2
  head "https://github.com/dimitri/pgloader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d7f926192e26b7e8a0e5d269370590d23a1d1c28e2323b6c2001e71088b2b8cd"
    sha256 cellar: :any_skip_relocation, catalina: "89145353b5e7cd483e99f88f9db350f678ee7281ebf06d2e02263d8ffa5a626c"
    sha256 cellar: :any_skip_relocation, mojave:   "d380bc8ea035e70afaaa5c913cf0ee4e4aedce19d7b29a6545297b59e512d0a8"
  end

  depends_on "buildapp" => :build
  depends_on "freetds"
  depends_on "openssl@1.1"
  depends_on "postgresql"
  depends_on "sbcl"

  # From https://github.com/dimitri/pgloader/issues/1218
  # Fixes: "Compilation failed: Constant NIL conflicts with its asserted type FUNCTION."
  patch :DATA

  def install
    system "make"
    bin.install "bin/pgloader"
  end
end
__END__
--- a/local-projects/cl-csv/parser.lisp
+++ b/local-projects/cl-csv/parser.lisp
@@ -31,12 +31,12 @@ See: csv-reader "))
     (ignore-errors (format s "~S" (string (buffer o))))))

 (defclass read-dispatch-table-entry ()
-  ((delimiter :type (vector (or boolean character))
+  ((delimiter :type (or (vector (or boolean character)) null)
               :accessor delimiter :initarg :delimiter :initform nil)
    (didx :type fixnum :initform -1 :accessor didx :initarg :didx)
    (dlen :type fixnum :initform 0 :accessor dlen :initarg :dlen)
    (dlen-1 :type fixnum :initform -1 :accessor dlen-1 :initarg :dlen-1)
-   (dispatch :type function :initform nil :accessor dispatch  :initarg :dispatch)
+   (dispatch :type (or function null) :initform nil :accessor dispatch  :initarg :dispatch)
    )
   (:documentation "When a certain delimiter is matched it will call a certain function
     T matches anything
