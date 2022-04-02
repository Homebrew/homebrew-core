class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.24.tar.gz"
  sha256 "f4746f1524cac58756123c7acbbc565e215d7f298a19667fd845dbba040c6021"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d2f8b650e92223e4565429c40167a9ef3587ae046257c385bf9b0da439d62da0"
    sha256 cellar: :any, arm64_big_sur:  "19fbe88e7d2224b59f9c8e2fc2f84903f189c9aaf6567194df72c08740f847a9"
    sha256 cellar: :any, monterey:       "2cf9eef6365101303f9d418f8691b86f7c489cd3f80f4e5856e8313a5efe5d24"
    sha256 cellar: :any, big_sur:        "5802416d35406c5e15ca284f50ca445495940643d27a996bd401606065444278"
    sha256 cellar: :any, catalina:       "62d1c125c7f461f7889b07445ce03d0c7de9993b463854e28ebda7ec822ec013"
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
