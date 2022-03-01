class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.23.tar.gz"
  sha256 "026f3986aae61d5f5cc7a95c7ad8ee9646f3249b282c8136a00b239bf6fed711"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "f402741efe099ad48be3d5bb48c6e591768179d0ff217cdbb4c3dffec3bf22bc"
    sha256 cellar: :any, arm64_big_sur:  "fb904cb7b2ae35f367b7d22ddb1bf813b113009a596b49ee10a1898d1ffe114a"
    sha256 cellar: :any, monterey:       "965647d46689d0b32401c6de7eb09d86d020025259ebd83de06ee603e96dcb6c"
    sha256 cellar: :any, big_sur:        "a15d4feb3beb53fe5c59e9962f1a7068c0cdc9d6b183e8ce36ace848ffde321a"
    sha256 cellar: :any, catalina:       "458f0308a0a564988e173a5fea7de76a1d7c06e2ce0ad8d7bb726f375d973a41"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on macos: :high_sierra # needs futimens

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
    ]
    system "./build-macosx", *args
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
