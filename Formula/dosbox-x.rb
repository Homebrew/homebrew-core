class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.14.tar.gz"
  sha256 "d27e1b796e22104c1cc822ee3255c07275e5ebbb6e29d8eda07dbf9feefc53e8"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ad4d2effe40286226e8ee42b7aed27cb2af35a067be28ffb4a1573079ce08321"
    sha256 cellar: :any, big_sur:       "b2901158b3c3f05400070e7945eb2ed78e45047f38300492221533bdbaf92505"
    sha256 cellar: :any, catalina:      "b9cade6c1b2065433e5c63f7a78145e1ae076bc25e50b5c4db8ced1bf51b7ac1"
    sha256 cellar: :any, mojave:        "c198efb3c463da7f10c5a09863ddc9248d4343a66ed323eab34f012ad4edd64b"
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
