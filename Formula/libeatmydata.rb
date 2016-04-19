require "erb"

class Libeatmydata < Formula
  desc "library to (transparently) disable fsync and friends."
  homepage "https://www.flamingspork.com/projects/libeatmydata/"
  url "https://www.flamingspork.com/projects/libeatmydata/libeatmydata-105.tar.gz"
  sha256 "bdd2d068b6b27cf47cd22aa4c5da43b3d4a05944cfe0ad1b0d843d360ed3a8dd"

  depends_on "coreutils"

  # This patch fixes three things:
  #
  # 1) `dpkg-architecture` only exists on Debian based platforms. This
  #    doesn't make much sense on OS X, so we'll just take it out.
  #
  # 2) OS X's built-in `readlink` doesn't recognize the `-f`
  #    (`--canonicalize`) flag, which is a GNU extension. The
  #    "coreutils" formula isn't linked in, so we have to modify this
  #    to use `greadlink` explicitly.
  #
  # 3) OS X doesn't seem to define an `open64` function by default. A
  #    more thorough fix would be to ensure it's covered in the
  #    Automake script, but I have no idea how to do that.
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # This is used by the test script.
    pkgshare.install "libeatmydata/test/eatmydatatest.c"

    # libexec isn't linked in and `DEB_BUILD_MULTIARCH` isn't defined,
    # so fix the path to `eatmydata.sh`.
    inreplace bin/"eatmydata" do |s|
      s.gsub! "/usr/lib/$DEB_BUILD_MULTIARCH/eatmydata.sh", libexec/"eatmydata.sh"
    end
  end

  test do
    system ENV.cc, pkgshare/"eatmydatatest.c", "-o", "eatmydatatest"
    system bin/"eatmydata", "./eatmydatatest"
  end
end

__END__
diff --git a/eatmydata.in b/eatmydata.in
index 40468db..9a9419c 100644
--- a/eatmydata.in
+++ b/eatmydata.in
@@ -14,8 +14,6 @@
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
-
-export `dpkg-architecture|grep DEB_BUILD_MULTIARCH`
 
 shlib="/usr/lib/$DEB_BUILD_MULTIARCH/eatmydata.sh"
 if [ -f "$shlib" ]; then
diff --git a/eatmydata.sh.in b/eatmydata.sh.in
index 40468db..9a9419c 100644
--- a/eatmydata.sh.in
+++ b/eatmydata.sh.in
@@ -38,14 +38,14 @@
         # $cmd does not contain '/'. Look in $PATH avoiding loops with self.
         local self save_ifs path exe ok
 
-        self="`readlink -f "$0"`"
+        self="`greadlink -f "$0"`"
         save_ifs="$IFS"
         IFS=":"
         ok=""
         for path in $PATH; do
             exe="${path}/$cmd"
             # Avoid loops with self
-            if [ -x "$exe" ] && [ "`readlink -f "$exe"`" != "$self" ]; then
+            if [ -x "$exe" ] && [ "`greadlink -f "$exe"`" != "$self" ]; then
                 ok="yes"
                 break
             fi
diff --git a/libeatmydata/libeatmydata.c b/libeatmydata/libeatmydata.c
index 9d38268..8fe1b6a 100644
--- a/libeatmydata/libeatmydata.c
+++ b/libeatmydata/libeatmydata.c
@@ -77,7 +77,7 @@ void __attribute__ ((constructor)) eatmydata_init(void)
 {
 	initing = 1;
 	ASSIGN_DLSYM_OR_DIE(open);
-	ASSIGN_DLSYM_OR_DIE(open64);
+	ASSIGN_DLSYM_IF_EXIST(open64);
 	ASSIGN_DLSYM_OR_DIE(fsync);
 	ASSIGN_DLSYM_OR_DIE(sync);
 	ASSIGN_DLSYM_OR_DIE(fdatasync);
