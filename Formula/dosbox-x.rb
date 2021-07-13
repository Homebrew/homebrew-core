class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.15.tar.gz"
  sha256 "06b9e0903e28841d21cd638d4a2133f4f90d8174c8b41c23767f7f0634efbee8"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4195bd9b6a9e0a80fa5e706bf72b6ce9ff4e33670b47b9db72272b724eabcffa"
    sha256 cellar: :any, big_sur:       "7786eff51ed40d4c5d6e57a5c809d40651e071b5ddf61424388747a81d36f492"
    sha256 cellar: :any, catalina:      "66193de59c50a4585ddc5f4aac0cd3b6080363fdfc9f17d37f9a01e5f0edc77e"
    sha256 cellar: :any, mojave:        "56a28018732b6f3cafa94fb6a8fe63f234700cd7e1ca56885dadd88e6208ae8e"
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
