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
    sha256 cellar: :any,                 arm64_monterey: "b95e41094fd2755ad5337b313c03234b08ae0587e811fb4c80f2d397ce3d2d98"
    sha256 cellar: :any,                 arm64_big_sur:  "8e2fc3b0df09a21840f8643f644bd3a0bb3c3551d21f600b344f6b316d3ef44d"
    sha256 cellar: :any,                 monterey:       "be628de52cd5464d69bd4c1558c44fd4ed0f9ed29ce2f3d8f2e6baf0be2c26fc"
    sha256 cellar: :any,                 big_sur:        "a4a734e58220fc8615d86e4563e9a874447d568151b366aa94391dfe07c4e0fb"
    sha256 cellar: :any,                 catalina:       "671a3cc9c7dafd89cbaffeccf4de826262c144184bf5779320c236e87e7636cc"
    sha256 cellar: :any,                 mojave:         "8b2876610f9188e8125f636e85bcbd525343b216c6d0787954e78b88dfe8f101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3949f7d627ea3a217a8f9461ee8ad7f333ed48f0490db897a5f03d9dfd5995f5"
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
