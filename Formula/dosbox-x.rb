class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.17.tar.gz"
  sha256 "5e5b4637982e0af8228de8fd38945b49c59a73300437a63964d5154da6dd2d1d"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "64ef1bc566adea246055e1791d1e8716751f5695ae61bb799ac259909572cc1a"
    sha256 cellar: :any, big_sur:       "925b7cdba50055e008b04a989dc216c9059032eaf6ac4753a00e1a6affa6370d"
    sha256 cellar: :any, catalina:      "1194968c068f8fc805b8aaaa997e7c186d6a4c14f6c3cf48fe33c24224fcddc5"
    sha256 cellar: :any, mojave:        "f90fd6277f496a58e0dcb1fa3f382dc822531b5aaf4067f2538db4b2d2b50970"
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
