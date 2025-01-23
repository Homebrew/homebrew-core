class LibpokerEval < Formula
  desc "C library to evaluate poker hands"
  homepage "https://pokersource.sourceforge.net/"
  # http://download.gna.org/pokersource/sources/poker-eval-138.0.tar.gz is offline
  url "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/poker-eval/138.0-1/poker-eval_138.0.orig.tar.gz"
  sha256 "92659e4a90f6856ebd768bad942e9894bd70122dab56f3b23dd2c4c61bdbcf68"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "becb0628bede0bab265c5fdd06c91ae705b1d53be58db78fc2edfdd4b79f1776"
    sha256 cellar: :any,                 arm64_sonoma:   "167fe5ff48e636128d58bf9c0645f58af77550669bf1f626b385adfbe20c4dd5"
    sha256 cellar: :any,                 arm64_ventura:  "a4cebe2f59bd06f50608c0df206de3cfa2d3512a54933ed3ae161a09dd499a84"
    sha256 cellar: :any,                 arm64_monterey: "a92ca2dd4b28f4280177846140b0d1db97dc12b855e481eaf3bef1211ee0de24"
    sha256 cellar: :any,                 arm64_big_sur:  "3b2910848df5a62c48ff9ecca9797de0c6c82c73e5392c0bc63202fd7a51815a"
    sha256 cellar: :any,                 sonoma:         "2c0023bc4da795dbade8572b92ba6aac7b5fd68ab945ee2f4e0d03739a960d1b"
    sha256 cellar: :any,                 ventura:        "47680460b617535c739e9185e07262ee04a63c449e0fed0decc319df46456f69"
    sha256 cellar: :any,                 monterey:       "48609ddd2db1e24baecede6fa77ef4845f4f48dfa0d8e8ce07b021c9f4552530"
    sha256 cellar: :any,                 big_sur:        "08b9a0817303ed87c19ce2345e92ccf6d1698d3b48f1d8ed7332663bb16dc227"
    sha256 cellar: :any,                 catalina:       "803f48db07d845ec9784792ed0fe5cdc86cb67e6632ed9f72dde75619481bf83"
    sha256 cellar: :any,                 mojave:         "313ff85dd7ec513a95ee8846c657819fdadbebccf0bdce228f180305ee56a716"
    sha256 cellar: :any,                 high_sierra:    "415934c921d4ccced5426f9aa807b0cf11da031cb2c973e17d506a9f740ac645"
    sha256 cellar: :any,                 sierra:         "5216cd33d433fd9212ed14d6fffec593c7106226547c1555344604186e7aafc6"
    sha256 cellar: :any,                 el_capitan:     "67b105600a8e29ed2d38421bc27340ff6e9092806f6458f0ddd6a27de0bcfb9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "723cc1e71146dbe997acaacd71fd71f46266de3977b0ee24f3cf54fae280d208"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
