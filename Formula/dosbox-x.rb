class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.84.1.tar.gz"
  sha256 "d5ba5b3d87b0dc69d70f6c9701eec36772bbc3716e0b201b74ec73d4b3ff38cc"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "d8d48cde31652f38141989d47761f98ca9244ebaa76b983219f4a47b9890db37"
    sha256 arm64_monterey: "ba141298043ea53e91b2b5e848cdafbba932522c2a4378f516ed00c8e7900f86"
    sha256 arm64_big_sur:  "857458e42569a07bd3672c737ada1d74c2f4540508781c7bdea836419d32f116"
    sha256 ventura:        "05bb7c5945061bc2f6ad72591062ed598e208dc5b084559494eb1792efac586f"
    sha256 monterey:       "48a99fb912507bfea08cb32d6d06b314ae2dd3d5d255da2a16b17e2dcf8b493b"
    sha256 big_sur:        "897591473da3931085825289853adbf8f860c438207a0cf66f343ab51721c946"
    sha256 catalina:       "22a718ddb857157def467dfff8d08bdb6272741d920ca05ccf6215190f5c9983"
    sha256 x86_64_linux:   "8e685d8d1494efa8b6ded6b1fd4346cdc786cf81976e1d1d1868c35c1f63a099"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on macos: :high_sierra # needs futimens
  depends_on "sdl2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-headers@5.15" => :build
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11

    # See flags in `build-macos-sdl2`.
    args = %w[
      --enable-core-inline
      --enable-sdl2
      --disable-sdl2test
      --disable-sdl
      --disable-sdltest
    ]

    system "./autogen.sh"
    system "./configure", *std_configure_args, *args
    system "make" # Needs to be called separately from `make install`.
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
