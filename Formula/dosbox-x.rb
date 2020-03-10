class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.0.tar.gz"
  sha256 "cc5beafa32bde866b5f54b46229feb743abee7dbd84becc9735709efb8189283"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "09505657fb2a1d1b701943d6dd762d4a8f07b098c10cc9adbfd7f24d45928c16" => :catalina
    sha256 "b2c32c4797edd865aea2bb1c4635741fefe9257353e68aaac4ef99c96e45cf99" => :mojave
    sha256 "5eabafbb606d7d78931e8b39dfae1876b9c5e82897297f1e70c7bbe141dfdfad" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fluid-synth"
  depends_on :macos => :high_sierra # needs futimens

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
    assert_match /DOSBox version #{version}/, shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
