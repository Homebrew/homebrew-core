class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.21.tar.gz"
  sha256 "79ebd5cf965e7eb127bd33109d83d5b34226d5f0d039a505882d8d20f72deb3b"
  revision 1

  bottle do
    cellar :any
    sha256 "ceacb500c58bd98fd2c078faeacce0dde98b68cdce37ee7ac380ab8eaf6a916b" => :mojave
    sha256 "f77ac0f2a941ddec78492f28fd67d24ce68cff6d3028015fa1a8205ec1d795b3" => :high_sierra
    sha256 "129b09f480dfe42180cd0bb546ad0e19f4ceb0532bc2c96ac46284a2706f7783" => :sierra
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  # Fix a buffer overflow issue.
  # See https://github.com/neovim/neovim/issues/9630#issuecomment-465261774
  patch :DATA

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end

__END__
diff --git a/driver-ti.c b/driver-ti.c
index 981d420..3fe3c52 100644
--- a/driver-ti.c
+++ b/driver-ti.c
@@ -291,7 +291,7 @@ static int load_terminfo(TermKeyTI *ti)
   /* First the regular key strings
    */
   for(i = 0; funcs[i].funcname; i++) {
-    char name[MAX_FUNCNAME + 4 + 1];
+    char name[MAX_FUNCNAME + 5 + 1];

     sprintf(name, "key_%s", funcs[i].funcname);
     if(!try_load_terminfo_key(ti, name, &(struct keyinfo){
