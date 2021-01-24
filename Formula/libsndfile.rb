class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "https://libsndfile.github.io/libsndfile/"
  url "https://github.com/libsndfile/libsndfile/releases/download/1.0.31/libsndfile-1.0.31.tar.bz2"
  sha256 "a8cfb1c09ea6e90eff4ca87322d4168cdbe5035cb48717b40bf77e751cc02163"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "ee9bc99bab89708e8f371173efc13c71c82d63cd46de50c4dd6ca89f4e2bd1f9" => :big_sur
    sha256 "0c6dd62351317eac23e245450cded41a654084da265d74cc25350b7aa8628d36" => :arm64_big_sur
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
