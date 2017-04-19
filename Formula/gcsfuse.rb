class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.21.0.tar.gz"
  sha256 "e379abf9e6ce1f9f522c03a86407803e2799b8d8abdbdb6396ba2c447655c0d7"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23a599117b658f33dc999c6246ea881f1d6651fe15b5e5142a2120c3ed63a93f" => :sierra
    sha256 "acad03f1ad38e9f53f6120d7194160767c4aefb8f7bc480cec0ab71637edf305" => :el_capitan
    sha256 "817b2e3443bf39027b7aadc20cfde103801cbf0447e641774718ce3ac4865781" => :yosemite
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
