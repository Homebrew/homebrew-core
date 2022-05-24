class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "https://libsndfile.github.io/libsndfile/"
  url "https://github.com/libsndfile/libsndfile/releases/download/1.1.0/libsndfile-1.1.0.tar.xz"
  sha256 "0f98e101c0f7c850a71225fb5feaf33b106227b3d331333ddc9bacee190bcf41"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "230aeebecdac8844737f4d4a83ad6c337b2fe58866dbaf140f9b94d72405c86c"
    sha256 cellar: :any,                 arm64_big_sur:  "6d19ec5ab5743e79fd49ae7155d062c262c324809e24f798e7be02c386a3b058"
    sha256 cellar: :any,                 monterey:       "ac4657b0a1614c0eec103a32d1ddc01a357272995cb72beaa7df9568d1ecf78d"
    sha256 cellar: :any,                 big_sur:        "0878aea928e51a22ba735372f4c3a6f2a144b8b63481c5a4667161747acc2e2f"
    sha256 cellar: :any,                 catalina:       "a16623865682e6fd8bfe3751d2f1f72eedba36b90cd09dde3d5d5e378b669f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d628a31397f0c0f7bf691b526f05fbac3167705d6f6cd9a474a84621eeeefda9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"

  # Fix unsubstituted variable @EXTERNAL_MPEG_LIBS@ in sndfile.pc
  # PR ref: https://github.com/libsndfile/libsndfile/pull/828
  # Remove in the next release.
  patch do
    url "https://github.com/libsndfile/libsndfile/commit/e4fdaeefddd39bae1db27d48ccb7db7733e0c009.patch?full_index=1"
    sha256 "af1e9faf1b7f414ff81ef3f1641e2e37f3502f0febd17f70f0db6ecdd02dc910"
  end

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/sndfile-info #{test_fixtures("test.wav")}")
    assert_match "Duration    : 00:00:00.064", output
  end
end
