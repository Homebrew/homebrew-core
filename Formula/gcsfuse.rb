class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.29.0.tar.gz"
  sha256 "4f994d694a12691b7ea5bd293c50ba4a37bc329cf531780015daf0a5fd265b30"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f77f535e3f254ee258ff0fc2789c3e3cbdcd5ae82752f20ba4b9d81f08b9784" => :catalina
    sha256 "34f2669361a227f30c00f70aa0e8787a049c845ef4ad010a5adcd98fecf3db34" => :mojave
    sha256 "6edf61db4afc7f42c57b2dd4867e8ca80224b5c924c5d1e8d5bfea9b24abf4a3" => :high_sierra
  end

  depends_on "go" => :build
  depends_on :osxfuse

  def install
    # Build the build_gcsfuse tool. Ensure that it doesn't pick up any
    # libraries from the user's GOPATH; it should have no dependencies.
    ENV.delete("GOPATH")
    system "go", "build", "./tools/build_gcsfuse"

    # Use that tool to build gcsfuse itself.
    gcsfuse_version = if build.head?
      `git rev-parse --short HEAD`.strip
    else
      version
    end

    system "./build_gcsfuse", buildpath, prefix, gcsfuse_version
  end

  test do
    system "#{bin}/gcsfuse", "--help"
    system "#{sbin}/mount_gcsfuse", "--help"
  end
end
