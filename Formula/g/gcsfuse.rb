class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v3.13.1.tar.gz"
  sha256 "8d2c2171243f075baeb62017f21c0b56fcabba3c508104c6ae7cc7ff061c0e8f"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a8c7712f43f4a43ef8a764e4265e08a0ecc5a3bd694654ba899bab674f65935a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "744929c29092d21db3288c309077c12f832595021460074ed886b951e873757c"
  end

  depends_on "go" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # `build_gcsfuse` builds with its own temporary GOPATH;
    # keep using the module cache populated in `fetch`.
    ENV["GOMODCACHE"] = "#{ENV.fetch("GOPATH")}/pkg/mod"

    # Build the build_gcsfuse tool.
    system "go", "build", "./tools/build_gcsfuse"

    # Use that tool to build gcsfuse itself.
    gcsfuse_version = build.head? ? Utils.git_short_head : version.to_s
    system "./build_gcsfuse", buildpath, prefix, gcsfuse_version
  end

  test do
    system bin/"gcsfuse", "--help"
    system sbin/"mount.gcsfuse", "--help"
  end
end
