class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.20.1.tar.gz"
  sha256 "cd79b22e9c00ddb2d747a2c0efb3dc73fd9fd19030767106154a3dab0009ff3f"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d30b6dc67105bccc275b1e76f366f14ecdffa9925ad8e0666e8ec12e1aa5c567" => :sierra
    sha256 "60c67924171752200d7a82119069e0ee7b33f770fb5d020cb3629b0524e3c479" => :el_capitan
    sha256 "d1b059510b0a0be2ef91e72c21fa65b7ffcde25def7d1bc7693c53bae58c1fe2" => :yosemite
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
