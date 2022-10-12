class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "https://libsndfile.github.io/libsndfile/"
  url "https://github.com/libsndfile/libsndfile/releases/download/1.1.0/libsndfile-1.1.0.tar.xz"
  sha256 "0f98e101c0f7c850a71225fb5feaf33b106227b3d331333ddc9bacee190bcf41"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9ed727cc18747f0a6d3719fb2d9eaee6b1ac6f0f246e25af94148f38d64474f6"
    sha256 cellar: :any,                 arm64_big_sur:  "dc8a056668adb95bd8cb09d8b26f9ba934e3a636161ab1858ec2c00bd29a30e5"
    sha256 cellar: :any,                 monterey:       "46ef23309fcd5a9719b32ac664a2311e3de8bbfae8f0b576a7910f7bcc1dbb75"
    sha256 cellar: :any,                 big_sur:        "9ae6459378ff5eb03da93314b33d88d1b3bb32fb920db887c049fbbe40edc016"
    sha256 cellar: :any,                 catalina:       "0c62f981692a252ee7d4b6403423437f084076139ec09c717ba0e73ace14148a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1ccedcb7ec0d71a45cc48a73112bc45b400c6d6c27a455709a3beb955d5266"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"

  uses_from_macos "python" => :build

  # Fix unsubstituted variable @EXTERNAL_MPEG_LIBS@ in sndfile.pc
  # PR ref: https://github.com/libsndfile/libsndfile/pull/828
  # Remove in the next release.
  patch do
    url "https://github.com/libsndfile/libsndfile/commit/e4fdaeefddd39bae1db27d48ccb7db7733e0c009.patch?full_index=1"
    sha256 "af1e9faf1b7f414ff81ef3f1641e2e37f3502f0febd17f70f0db6ecdd02dc910"
  end

  def install
    system "autoreconf", "-fvi"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/sndfile-info #{test_fixtures("test.wav")}")
    assert_match "Duration    : 00:00:00.064", output
  end
end
