class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.23.0.tar.gz"
  sha256 "beb90ef68d5ab673bf09357c90d1ace94695bebb6f823ba715a92b30e61e7c39"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2c81182f6f0fee8446e9c71eca974d0871ba99ea8d0f18e3041cddbd0b31ea5" => :sierra
    sha256 "1125037fbc7cb06dd1406c043275d9271b3c300c1636766c0720b7954773538f" => :el_capitan
    sha256 "7d07d3bed7acc1248f99f9209c8e4a8911ec364da23bab696fd92b13127847ac" => :yosemite
  end

  depends_on :osxfuse

  depends_on "go" => :build

  def install
    # Build the build_gcsfuse tool. Ensure that it doesn't pick up any
    # libraries from the user's GOPATH; it should have no dependencies.
    ENV.delete("GOPATH")
    system "go", "build", "./tools/build_gcsfuse"

    # Use that tool to build gcsfuse itself.
    if build.head?
      gcsfuse_version = `git rev-parse --short HEAD`.strip
    else
      gcsfuse_version = version
    end

    system "./build_gcsfuse", buildpath, prefix, gcsfuse_version
  end

  test do
    system "#{bin}/gcsfuse", "--help"
    system "#{sbin}/mount_gcsfuse", "--help"
  end
end
