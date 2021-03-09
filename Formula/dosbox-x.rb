class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.11.tar.gz"
  sha256 "d65c96349a921e9843914e5b852ef926e4fff3ae22d9ebd8490b534afec85717"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b69391d65116d0671de8a81c4f2605edfb0a3d1451e2f713d8cc992c97f48203"
    sha256 cellar: :any, big_sur:       "d8f94ea5053977241263e0bab8a55bcc7709d1eb4a9c303a082f2be7daf131ba"
    sha256 cellar: :any, catalina:      "b29cba95b2789ea7c56d9b3dcb85f3729c6ea1d509e944d6395c5f702c189a11"
    sha256 cellar: :any, mojave:        "0502f349d980682f925eeaf160c06c96cda7247af12e2b39e95cd0ce14ce083a"
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
