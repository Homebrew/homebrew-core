class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.27.0.tar.gz"
  sha256 "a60c22360c79b008b561f8636d0736a9275428b11cf29387c0ddd96f05f830f8"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a4cd4e709432ca2078685e8729ecf8f5b93f54cc47bbc236ba82f5378c04c56" => :mojave
    sha256 "e7e27dfed6f1d55255df55b2880bf1b930d20a0ba3b848bf659fd96683ef2134" => :high_sierra
    sha256 "28dde861009219d5f9ef963eb83b4471cee045696c8321720fe342844119d750" => :sierra
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
