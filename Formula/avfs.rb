class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.0.2/avfs-1.0.2.tar.bz2"
  sha256 "52693953e8290281d441a898040c5ac2989f11bc1fcb83ca5063c37a125a1c9a"

  depends_on "pkg-config" => :build
  depends_on "xz" => :recommended # Upstream recommends building with lzma support.
  depends_on "openssl" => :optional
  depends_on :osxfuse

  # Fix scripts to work on Mac OS X.
  # Nothing the patch fixes has been changed in 1.0.2, so still necessary.
  patch :DATA

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--enable-fuse",
      "--enable-library",
    ]

    args << "--with-ssl=#{Formula["openssl"].opt_prefix}" if build.with? "openssl"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"avfsd", "--version"
  end
end

__END__
diff --git i/scripts/mountavfs w/scripts/mountavfs
index 5722dcd..a35e633 100755
--- i/scripts/mountavfs
+++ w/scripts/mountavfs
@@ -14,7 +14,7 @@ else
     MntDir=${HOME}/.avfs
 fi

-grep -qE "avfsd ${MntDir}" /proc/mounts || {
+grep -qE "avfsd.*${MntDir}" < <(mount) || {
    if [ ! -e "$MntDir" ]; then
       mkdir -p "$MntDir"
    fi
diff --git i/scripts/umountavfs w/scripts/umountavfs
index 09dc629..a242c21 100644
--- i/scripts/umountavfs
+++ w/scripts/umountavfs
@@ -14,11 +14,11 @@ else
     MntDir="${HOME}/.avfs"
 fi

-grep -qE "${MntDir}.*avfsd" /proc/mounts && {
+grep -qE "avfsd.*${MntDir}" < <(mount) && {
    echo unMounting AVFS on $MntDir...
    if type -p fusermount > /dev/null 2>&1 ; then
       fusermount -u -z "$MntDir"
    else
-      umount -l "$MntDir"
+      umount "$MntDir"
    fi
 }
