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
    sha256 cellar: :any,                 arm64_monterey: "dbbcfc8f13b9a8ba9972e7b7b801b7157468d722450fc58e43e6a0e790376a89"
    sha256 cellar: :any,                 arm64_big_sur:  "c3520f174dbeb0a4437bbdd620f2a5d50c5ef2c69f6f629d25fdcef96e27a1bc"
    sha256 cellar: :any,                 monterey:       "b0ecbc68df351810a9c7b787488b0dc20eb7315cc77363a94e5959aba91e694a"
    sha256 cellar: :any,                 big_sur:        "6a1e5ff8f9a83925cb92ca2fd4e898a231fb553607d0b209d5d101972c1f04c4"
    sha256 cellar: :any,                 catalina:       "7d5dc49ca6e980ecc8eaa5950973ac5a51451bac0074a97483afdf2cf1f0a922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cda053c640ee0d504ce50f32bf61085599cfd961db3be6cef2ba9f8013e79863"
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
