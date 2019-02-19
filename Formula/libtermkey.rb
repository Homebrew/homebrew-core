class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.21.tar.gz"
  sha256 "79ebd5cf965e7eb127bd33109d83d5b34226d5f0d039a505882d8d20f72deb3b"
  revision 1

  bottle do
    cellar :any
    sha256 "0ae9676373ff11d14f39f5c0a7e517378caf6ba13a67606d12709a7fb4e45d02" => :mojave
    sha256 "bad5f2f612c39249aa79c59bffb3f00ce8a0ccfba53a736ca59be2532b58ae89" => :high_sierra
    sha256 "8eb5123844700c8c85cf6c83997bc6a02e8f7c69295ecdb8d3954a5b1dfd6ba3" => :sierra
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
