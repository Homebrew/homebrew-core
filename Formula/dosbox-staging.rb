class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.75.0.tar.gz"
  sha256 "6279690a05b9cc134484b8c7d11e9c1cb53b50bdb9bf32bdf683bd66770b6658"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on :macos => :catalina # Github CI and Apple SDKs limitations
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "sdl2_net"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --program-suffix=-staging
      --disable-debug
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-sdltest
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match /dosbox \(dosbox-staging\), version #{version}/,
      shell_output("#{bin}/dosbox-staging -version 2>&1")
  end
end
