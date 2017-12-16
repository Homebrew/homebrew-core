class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v1.4.2/gocryptfs_v1.4.2_src-deps.tar.gz"
  version "1.4.2"
  sha256 "74e896cbab9beae05c668248d3b2d1a6b3839d72d0e277cde6396e4c1858f1e0"

  depends_on :osxfuse
  depends_on "go"
  depends_on "openssl"
  depends_on "pkg-config" => :build

  # load_osxfuse needs to be run once per reboot
  # https://github.com/hanwen/go-fuse/pull/197
  patch :DATA

  def install
    mkdir_p "src/github.com/rfjakob/gocryptfs"
    mv Dir["*"].reject { |d| d["src"] }, "src/github.com/rfjakob/gocryptfs/"
    cd "src/github.com/rfjakob/gocryptfs"

    ENV["GOPATH"]=buildpath.to_s
    ENV["CGO_CFLAGS"]="-I#{Formula["openssl"].opt_include}"
    ENV["CGO_LDFLAGS"]="-L#{Formula["openssl"].opt_lib}"
    system "./build.bash"

    bin.install "gocryptfs"
  end

  test do
    mkdir "encrypted"
    mkdir "plain"

    system "printf 'ilovezfstoo\n' | #{bin}/gocryptfs -init encrypted"
    system "printf 'ilovezfstoo\n' | #{bin}/gocryptfs encrypted plain"

    touch "plain/test"

    umount "plain"

    File.exist?("encrypted/qfl6rlPkUYJ6BpxUceLzRw")
  end
end

__END__
diff --git a/vendor/github.com/hanwen/go-fuse/fuse/mount_darwin.go b/vendor/github.com/hanwen/go-fuse/fuse/mount_darwin.go
index 5aa0f6ab..845c93c8 100644
--- a/vendor/github.com/hanwen/go-fuse/fuse/mount_darwin.go
+++ b/vendor/github.com/hanwen/go-fuse/fuse/mount_darwin.go
@@ -20,8 +20,15 @@ func openFUSEDevice() (*os.File, error) {
 		return nil, err
 	}
 	if len(fs) == 0 {
-		// TODO(hanwen): run the load_osxfuse command.
-		return nil, fmt.Errorf("no FUSE devices found")
+		bin := oldLoadBin
+		if _, err := os.Stat(newLoadBin); err == nil {
+			bin = newLoadBin
+		}
+		cmd := exec.Command(bin)
+		if err := cmd.Run(); err != nil {
+			return nil, err
+		}
+		return openFUSEDevice()
 	}
 	for _, fn := range fs {
 		f, err := os.OpenFile(fn, os.O_RDWR, 0)
@@ -37,6 +44,9 @@ func openFUSEDevice() (*os.File, error) {
 const oldMountBin = "/Library/Filesystems/osxfusefs.fs/Support/mount_osxfusefs"
 const newMountBin = "/Library/Filesystems/osxfuse.fs/Contents/Resources/mount_osxfuse"
 
+const oldLoadBin = "/Library/Filesystems/osxfusefs.fs/Support/load_osxfusefs"
+const newLoadBin = "/Library/Filesystems/osxfuse.fs/Contents/Resources/load_osxfuse"
+
 func mount(mountPoint string, opts *MountOptions, ready chan<- error) (fd int, err error) {
 	f, err := openFUSEDevice()
 	if err != nil {
