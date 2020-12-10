class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "https://libsndfile.github.io/libsndfile/"
  url "https://github.com/erikd/libsndfile/releases/download/v1.0.30/libsndfile-1.0.30.tar.bz2"
  sha256 "9df273302c4fa160567f412e10cc4f76666b66281e7ba48370fb544e87e4611a"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "ee9bc99bab89708e8f371173efc13c71c82d63cd46de50c4dd6ca89f4e2bd1f9" => :big_sur
    sha256 "8777b541acc126315428bcee3f3453a240157dcdca48d2e51609158ad3539284" => :catalina
    sha256 "eaa0e886d88536970a5618557f1fb4e7a06d0c1429bf8bcb874cd90e31e05e0a" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"

  # Upstream commit to fix autotools configure on macOS, fixes
  # https://github.com/libsndfile/libsndfile/issues/642
  # Upstream fix is expected in release v1.0.31
  patch do
    url "https://github.com/libsndfile/libsndfile/commit/ecd63961.patch?full_index=1"
    sha256 "419aad070487685157a515adf4c6de25ffbd34adb0ab52b6df0f7c1ed0644893"
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
