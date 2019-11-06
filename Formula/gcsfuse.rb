class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.28.1.tar.gz"
  sha256 "26a468622e5a0450a6bfbb4853f1c0df3b031e5f8fe5b0c147c1200a1a8ee137"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a035c82776f016a0c193e23cb6b568ee1bc7d0c5397651f754c778850114cd69" => :catalina
    sha256 "aa49fbe598db8eb7ef274008954e72f237255d97bb65fbc68a2492d4c040a8b6" => :mojave
    sha256 "91ff3a7ec412eb76dadc39ca79ce16b85594ae3d5e171ba43a40f6357264cb30" => :high_sierra
    sha256 "f871bb6047f5761bfa369d9a578c9512d6e47675be7aeb2f9855de98f08bc6e3" => :sierra
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
