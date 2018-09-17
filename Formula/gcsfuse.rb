class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.23.0.tar.gz"
  sha256 "beb90ef68d5ab673bf09357c90d1ace94695bebb6f823ba715a92b30e61e7c39"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eead935b1d85374d650e4f1d0b9edbd5c7a65626bf2513592823be60b92795f8" => :mojave
    sha256 "4b0e7e4e145c199f18d21293e4002b8a6d3e626e5b5f330daee08ccfc3f1d7d9" => :high_sierra
    sha256 "9f42846472bbe6bc06b1016f6494415b16e148de6262fdcbb5bf9677fbee0a36" => :sierra
    sha256 "f4a837589708aed85da5762394004fa2398a2e907b37cb1c9554282578e635e7" => :el_capitan
    sha256 "4f1e5e0db02f9f148a61d9062626f754ba3f55dcf8df9ff69fc0f84cf5363577" => :yosemite
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
