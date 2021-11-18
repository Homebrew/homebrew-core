class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faac/archive/refs/tags/1_30.tar.gz"
  sha256 "adc387ce588cca16d98c03b6ec1e58f0ffd9fc6eadb00e254157d6b16203b2d2"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a45fd10b7c7e23fae859f1316f8a3c2b49bbe619da0abce66e44627c0733d237"
    sha256 cellar: :any,                 arm64_big_sur:  "6438d37d23478f1ece8c5370b62298d756b331de7bda2780ee64ef8446da7f19"
    sha256 cellar: :any,                 monterey:       "5f514bb28b0fd91b8335e01aa6c6c563df7f25a41a8e4eac224ccaae8511549d"
    sha256 cellar: :any,                 big_sur:        "15eb46101d9d0e50c8b87977f8b87dceafa4e9c0c165a2ff9a41fd94afe73b66"
    sha256 cellar: :any,                 catalina:       "5687b72d43334c52e8b4daa4eda547d9541812807bf7b89d63be9a1e487ae78f"
    sha256 cellar: :any,                 mojave:         "27f7a5da217b0cb75caa8fd33bd19dc5a1f741b290f30b0c5491bc3a84aed38c"
    sha256 cellar: :any,                 high_sierra:    "73e02bf58df497bf2c35e8374c000fc8ed989c167b559b9efe2f5874687fe849"
    sha256 cellar: :any,                 sierra:         "9ed007e0aaeaddb47d284a81f2783c6ddcf9af86e0ed1da1a9b94aa84dfd1a34"
    sha256 cellar: :any,                 el_capitan:     "4dd46a72ce3a5355efa42038df34b9bfda51ae6265be89eb09f1b8957ef3653d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55278dcfd35bcc01b566eeb8296b19b8bf5fca058cb9ca4616d3702940f919a4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert_predicate testpath/"test.m4a", :exist?
  end
end
