class Mpegdemux < Formula
  desc "MPEG1/2 system stream demultiplexer"
  homepage "http://www.hampa.ch/mpegdemux/"
  url "http://www.hampa.ch/mpegdemux/mpegdemux-0.1.5.tar.gz"
  sha256 "05015755d45e50cbd3018baeaa8abcedc003b1162fa28237a72ab25c1bc00023"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?mpegdemux[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c8009d2002ba680af6e0ef4d3addb176638b15450967b07caa5817f95606e80b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "596de6513b152e156fcffbfb37e42b097606fc3efed168190998049ddef8b9ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a5ac9ee81a39717100b75106922b741f5adf919ff9351dd72abdd659f0575a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b4354702d4ee60e1833b2f000b5af4cc5c84a27af849019ea75098d99db68b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e64ed694831f706e6cfd725a80b26d30c2bb1cdef38f38d21be95a2e99a59163"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93ff20adcb624347b095c7a23077f3f81f22a0be2711f115c7fa603dd3b88201"
    sha256 cellar: :any_skip_relocation, sonoma:         "f803850378b1602a599253c2d247c7473f8db4f5db4acc0bdd230e08f091622d"
    sha256 cellar: :any_skip_relocation, ventura:        "c8863fbff37e02aa161d6ac35e1e8552a0767ae61029c5104f369e6cce1cf1be"
    sha256 cellar: :any_skip_relocation, monterey:       "6d51b1329330fcd787cb942b0a76eda4f137494f4b32848692e63ce5b8e1c180"
    sha256 cellar: :any_skip_relocation, big_sur:        "eae7b45d33e2f663769c14d3957b39905060a37db101d5d42366f4ba6dc76934"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ea5d1210f203661390c44054f5b5cdddac0989530e733cf077d52bb325f3c93b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd54e487becb88cdbd5e2acad97281980762b9de0c49f44df81d43d1273afcc1"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mpegdemux", "--help"
  end
end
