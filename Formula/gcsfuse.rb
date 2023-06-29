class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v1.0.0.tar.gz"
  sha256 "0a6bb17372e3b3cfed5171fa82fda508e6168d119c2bbfea9d183c3efb7ee2fe"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6fdd1cb7996cc409565f35a1bcbef11f5dcecacc620e8096aa75f588473009eb"
  end

  # gcc-11: The build tool has reset ENV; --env=std required.
  depends_on "go@1.19" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  patch :DATA

  def install
    # Build the build_gcsfuse tool. Ensure that it doesn't pick up any
    # libraries from the user's GOPATH; it should have no dependencies.
    ENV.delete("GOPATH")
    system "go", "build", "./tools/build_gcsfuse"

    # Use that tool to build gcsfuse itself.
    gcsfuse_version = build.head? ? Utils.git_short_head : version
    system "./build_gcsfuse", buildpath, prefix, gcsfuse_version
  end

  test do
    system "#{bin}/gcsfuse", "--help"
    system "#{sbin}/mount.gcsfuse", "--help"
  end
end

__END__
diff --git a/tools/build_gcsfuse/main.go b/tools/build_gcsfuse/main.go
index af26596..2454aab 100644
--- a/tools/build_gcsfuse/main.go
+++ b/tools/build_gcsfuse/main.go
@@ -136,9 +136,7 @@ func buildBinaries(dstDir, srcDir, version string, buildArgs []string) (err erro
 			"go",
 			"build",
 			"-o",
-			path.Join(dstDir, bin.outputPath),
-			"-C",
-			srcDir)
+			path.Join(dstDir, bin.outputPath))

 		if path.Base(bin.outputPath) == "gcsfuse" {
 			cmd.Args = append(
