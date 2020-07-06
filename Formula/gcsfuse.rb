class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.30.0.tar.gz"
  sha256 "930e3c15a9f3fa8b79023442b549f7813f5bf95739097f41000bff5ded9db66d"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f17d670c7a662c8d16aa651b822b754507e22a2d6e4594aea1b0310d3aefb6f6" => :catalina
    sha256 "4088dc349ce2baba035e901b93a5347a8cbe38600a28845a9883abc35d534d6f" => :mojave
    sha256 "3935cf67d77796530c79ae81d493c9b82477ddc891f07b92e3553df8be833a61" => :high_sierra
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
