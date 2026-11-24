class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "c464b321e541713839d0fa72f7122b82c1460b2d2a721c55a8bb4e4ee04860ef"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    manifest_sha256 "3a6fe275145d71510108782e5bd23e25df1ec23d6452974297947419fbf8f2fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "b273d9fbe300ca37e1bc2668b959081ea09dde45ce43f9805ab2580758a6499d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7eac9a5c506ab5fc324e12679f8855d72cdb725bf006c038cd2b072e1a3aca4c"
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
