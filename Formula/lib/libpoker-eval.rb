class LibpokerEval < Formula
  desc "C library to evaluate poker hands"
  homepage "https://pokersource.sourceforge.net/"
  # http://download.gna.org/pokersource/sources/poker-eval-138.0.tar.gz is offline
  url "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/poker-eval/138.0-1/poker-eval_138.0.orig.tar.gz"
  sha256 "92659e4a90f6856ebd768bad942e9894bd70122dab56f3b23dd2c4c61bdbcf68"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "6f5762c63d4446544cc57abeea2c605b43442f035a34401d50c4d437257f6ad3"
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
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6d17810f1cdeacb43e5ec95d567c84f39eb99582058d5d3ac2f110cca04d01b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "723cc1e71146dbe997acaacd71fd71f46266de3977b0ee24f3cf54fae280d208"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end
end
