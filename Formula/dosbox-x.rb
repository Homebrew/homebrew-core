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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "52c5fb52ac48c0a76118fe9f74b9be5b2e076a129d80c4d8f1da38dd7df87f43"
    sha256 cellar: :any_skip_relocation, big_sur:       "c29df661964c656d222db48bf34d105dfccac08cffb5f04e443644b16fa400a0"
    sha256 cellar: :any_skip_relocation, catalina:      "40c23b8254b2bbf758e601057516ce84d0720300d76fa0d7c582ca04586ab4d2"
    sha256 cellar: :any_skip_relocation, mojave:        "5da9383563cc888fb49ff4de83423aa03b480d789924b9ef1282f76a4d0b4369"
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
