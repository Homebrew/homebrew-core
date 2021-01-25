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
    sha256 "a4a734e58220fc8615d86e4563e9a874447d568151b366aa94391dfe07c4e0fb" => :big_sur
    sha256 "8e2fc3b0df09a21840f8643f644bd3a0bb3c3551d21f600b344f6b316d3ef44d" => :arm64_big_sur
    sha256 "671a3cc9c7dafd89cbaffeccf4de826262c144184bf5779320c236e87e7636cc" => :catalina
    sha256 "8b2876610f9188e8125f636e85bcbd525343b216c6d0787954e78b88dfe8f101" => :mojave
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
