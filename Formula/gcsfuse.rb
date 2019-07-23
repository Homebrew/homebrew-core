class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.28.1.tar.gz"
  sha256 "26a468622e5a0450a6bfbb4853f1c0df3b031e5f8fe5b0c147c1200a1a8ee137"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "230b369c0fbaae5d333b9aec107f1fefc27f85232d74095a47851630eb9ec306" => :mojave
    sha256 "4950b4ce77e3db24eee4fdfcdd573d7a9eb010a373e30e87b6854358257d3bff" => :high_sierra
    sha256 "bf8a520a19886681d27279b29484f44cb6794822945aa4cd9d7617e11d5b729e" => :sierra
  end

  depends_on "go" => :build
  depends_on :osxfuse

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
