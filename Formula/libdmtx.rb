class Libdmtx < Formula
  desc "Data Matrix library"
  homepage "https://libdmtx.sourceforge.io"
  url "https://github.com/dmtx/libdmtx/archive/v0.7.5.tar.gz"
  sha256 "be0c5275695a732a5f434ded1fcc232aa63b1a6015c00044fe87f3a689b75f2e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ce71f3ec0a684dfa503a7c530104d40866821d3c6f28370f975223562c502360"
    sha256 cellar: :any,                 arm64_big_sur:  "1968ce1608f0ad9e8fc7e845f5ed894ca0c7decdb555aa68fec8d35340345984"
    sha256 cellar: :any,                 monterey:       "0202473ef15e2d5a70b670a5dfbff335f2af821b32bc44196d7d466e26827cd8"
    sha256 cellar: :any,                 big_sur:        "4f64097111d22436cd27a92ff5f5e3e7e5c620c3f7756de4d41dcf4766a6f9bb"
    sha256 cellar: :any,                 catalina:       "b4e2a70da91f992862a3609e5e79b9aedc648c97e374b75e701d95eef88b8133"
    sha256 cellar: :any,                 mojave:         "4631cea68d83f274390ff023591256a92fb108b685c0528448a43a48d583c09b"
    sha256 cellar: :any,                 high_sierra:    "eb892feb7d29f9291a0edc2be6c34b4584614103d4af9d1c62eb54370decd8e1"
    sha256 cellar: :any,                 sierra:         "c93913cd5aff29278c538957fd6890d990f760abaff1b14cea6f6f171194b706"
    sha256 cellar: :any,                 el_capitan:     "ebcd82bf4d9da2a71bd066722ce6750d6cf064b1c8f477ba9aca47987acd330c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba37ec45b9492f74b57f46960e60f4d81fb58a74ac6b2dd89d8378ddec186f47"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
